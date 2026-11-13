<?php

declare(strict_types=1);

namespace STA;

use DateTimeImmutable;

/**
 * Server-side authentication and session management.
 *
 * - Passwords use password_hash()/password_verify() (bcrypt).
 * - Legacy browser PBKDF2-SHA256 hashes are still accepted once, then
 *   silently upgraded to bcrypt on the next successful sign-in.
 * - Session authority lives in MySQL (sessions table) and the cookie
 *   only carries a random, revocable token.
 */
final class Auth
{
    /** A valid bcrypt hash used only to equalise timing for unknown users. */
    private const DUMMY_HASH = '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi';

    private const LOWERS = 'abcdefghijkmnopqrstuvwxyz';
    private const UPPERS = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
    private const DIGITS = '23456789';

    /** @return array<string, mixed>|null */
    public static function findByUsername(string $username): ?array
    {
        return Database::one('SELECT * FROM users WHERE username = ? LIMIT 1', [trim($username)]);
    }

    /** @return array<string, mixed>|null */
    public static function findById(int $id): ?array
    {
        return Database::one('SELECT * FROM users WHERE id = ? LIMIT 1', [$id]);
    }

    public static function hashPassword(string $password): string
    {
        return password_hash($password, PASSWORD_DEFAULT);
    }

    /** @param array<string, mixed> $user */
    public static function verifyCredentials(array $user, string $password): bool
    {
        $hash = $user['password_hash'] ?? null;

        if (is_string($hash) && $hash !== '' && password_verify($password, $hash)) {
            return true;
        }

        $legacy = $user['legacy_password_hash'] ?? null;

        if (is_string($legacy) && $legacy !== '') {
            return self::verifyLegacyPbkdf2($password, $legacy);
        }

        return false;
    }

    /**
     * Verify the old browser format: pbkdf2$<iterations>$<base64 salt>$<base64 digest>.
     */
    public static function verifyLegacyPbkdf2(string $password, string $stored): bool
    {
        $parts = explode('$', $stored);

        if (count($parts) !== 4 || $parts[0] !== 'pbkdf2') {
            return false;
        }

        $iterations = (int) $parts[1];

        if ($iterations < 1000 || $iterations > 1000000) {
            return false;
        }

        $salt = base64_decode($parts[2], true);
        $expected = base64_decode($parts[3], true);

        if ($salt === false || $expected === false || $salt === '' || $expected === '' || strlen($expected) > 64) {
            return false;
        }

        $derived = hash_pbkdf2('sha256', $password, $salt, $iterations, strlen($expected), true);

        return hash_equals($expected, $derived);
    }

    /**
     * Try to sign in. Never reveals whether the username exists.
     *
     * @return array{ok: bool, user?: array<string, mixed>, code?: string, error?: string}
     */
    public static function attempt(string $username, string $password, ?string $portalRole = null, ?string $ip = null): array
    {
        $username = trim($username);
        $ip = $ip ?? self::clientIp();

        if ($username === '' || $password === '') {
            return ['ok' => false, 'code' => 'invalid', 'error' => 'Invalid username or password. Please try again.'];
        }

        $user = self::findByUsername($username);

        if ($user !== null && self::lockedUntilActive($user)) {
            self::logAttempt($username, $ip, false);
            self::audit('auth.login.locked', 'Locked account attempted: ' . $username, (int) $user['id']);
            return [
                'ok'    => false,
                'code'  => 'locked',
                'error' => 'Too many failed attempts. Please wait a few minutes and try again.',
            ];
        }

        if (self::tooManyRecentFailures($username, $ip)) {
            self::logAttempt($username, $ip, false);
            self::audit('auth.login.rate_limited', 'Rate limit hit for: ' . $username, $user ? (int) $user['id'] : null);
            return [
                'ok'    => false,
                'code'  => 'rate_limited',
                'error' => 'Too many failed attempts. Please wait a few minutes and try again.',
            ];
        }

        if ($user === null) {
            password_verify($password, self::DUMMY_HASH);
            self::logAttempt($username, $ip, false);
            self::audit('auth.login.fail', 'Failed sign-in for unknown user: ' . $username);
            return ['ok' => false, 'code' => 'invalid', 'error' => 'Invalid username or password. Please try again.'];
        }

        if (!self::verifyCredentials($user, $password)) {
            self::logAttempt($username, $ip, false);
            self::recordFailure($user);
            self::audit('auth.login.fail', 'Failed sign-in for ' . $username, (int) $user['id']);
            return ['ok' => false, 'code' => 'invalid', 'error' => 'Invalid username or password. Please try again.'];
        }

        if (($user['status'] ?? 'active') !== 'active') {
            self::logAttempt($username, $ip, false);
            self::audit('auth.login.disabled', 'Disabled account sign-in blocked: ' . $username, (int) $user['id']);
            return [
                'ok'    => false,
                'code'  => 'disabled',
                'error' => 'This account has been disabled. Contact the administrator to have it reactivated.',
            ];
        }

        if ((int) $user['must_change_password'] === 1 && self::tempPasswordExpired($user)) {
            self::logAttempt($username, $ip, false);
            return [
                'ok'    => false,
                'code'  => 'temp_expired',
                'error' => 'This temporary password has expired. Ask an administrator to issue you a new one.',
            ];
        }

        if ($portalRole !== null && $portalRole !== '' && $user['role'] !== $portalRole) {
            self::logAttempt($username, $ip, false);
            self::audit('auth.login.role_mismatch', 'Wrong portal for ' . $username, (int) $user['id']);
            return [
                'ok'    => false,
                'code'  => 'role_mismatch',
                'error' => 'These credentials belong to a different portal. Please select the correct portal tab and try again.',
            ];
        }

        self::logAttempt($username, $ip, true);
        self::upgradePasswordHash($user, $password);
        self::audit('auth.login.success', 'Signed in: ' . $username . ' (' . $user['role'] . ')', (int) $user['id']);

        return ['ok' => true, 'user' => $user];
    }

    /**
     * Start the authenticated session. Requires an active PHP session.
     *
     * @param array<string, mixed> $user
     */
    public static function loginUser(array $user): void
    {
        if (session_status() !== PHP_SESSION_ACTIVE) {
            throw new \RuntimeException('Cannot start a login without an active PHP session.');
        }

        session_regenerate_id(true);

        $rawToken = bin2hex(random_bytes(32));
        $lifetime = (int) Config::get('session.lifetime', 7200);
        $expires  = date('Y-m-d H:i:s', time() + $lifetime);
        $csrf     = bin2hex(random_bytes(32));

        $_SESSION['user_id']    = (int) $user['id'];
        $_SESSION['auth_token'] = $rawToken;
        $_SESSION['csrf_token'] = $csrf;

        Database::execute('DELETE FROM sessions WHERE expires_at < NOW()');
        Database::execute(
            'INSERT INTO sessions (id, user_id, csrf_token, ip, user_agent, expires_at, created_at, last_seen_at)
             VALUES (?, ?, ?, ?, ?, ?, NOW(), NOW())',
            [
                hash('sha256', $rawToken),
                (int) $user['id'],
                $csrf,
                self::clientIp(),
                self::userAgent(),
                $expires,
            ]
        );

        Database::execute(
            'UPDATE users SET last_login_at = NOW(), failed_login_count = 0, locked_until = NULL WHERE id = ?',
            [(int) $user['id']]
        );
    }

    /** @return array<string, mixed>|null */
    public static function currentUser(): ?array
    {
        if (session_status() !== PHP_SESSION_ACTIVE) {
            return null;
        }

        $id       = (int) ($_SESSION['user_id'] ?? 0);
        $rawToken = $_SESSION['auth_token'] ?? '';

        if ($id <= 0 || !is_string($rawToken) || $rawToken === '') {
            return null;
        }

        $row = Database::one(
            'SELECT u.*
               FROM sessions s
               INNER JOIN users u ON u.id = s.user_id
              WHERE s.id = ?
                AND s.user_id = ?
                AND s.expires_at > NOW()
                AND u.status = \'active\'
              LIMIT 1',
            [hash('sha256', $rawToken), $id]
        );

        if ($row === null) {
            self::clearSession();
            return null;
        }

        return $row;
    }

    /**
     * Require a signed-in user, optionally restricted to roles.
     *
     * @param list<string> $roles
     * @return array<string, mixed>
     */
    public static function requireUser(array $roles = [], bool $json = false): array
    {
        $user = self::currentUser();

        if ($user === null) {
            if ($json) {
                Response::json(['ok' => false, 'error' => 'Please sign in.'], 401);
            }
            Response::redirect(self::loginUrl());
        }

        if ((int) $user['must_change_password'] === 1 && self::tempPasswordExpired($user)) {
            if ($json) {
                Response::json(['ok' => false, 'error' => 'Your temporary password has expired.'], 403);
            }
            Response::redirect(self::changePasswordUrl() . '?expired=1');
        }

        /* A temporary password must be replaced before any portal or API
           action is allowed, even when JavaScript is disabled. */
        if ((int) $user['must_change_password'] === 1) {
            if ($json) {
                Response::json(['ok' => false, 'error' => 'Please set a new password before continuing.'], 403);
            }
            Response::redirect(self::changePasswordUrl());
        }

        if ($roles !== [] && !in_array($user['role'], $roles, true)) {
            if ($json) {
                Response::json(['ok' => false, 'error' => 'You do not have permission to do this.'], 403);
            }
            Response::redirect(self::loginUrl());
        }

        return $user;
    }

    /**
     * Change your own password. The current password is always required.
     *
     * @return array{ok: bool, error?: string}
     */
    public static function changePassword(int $userId, string $currentPassword, string $newPassword): array
    {
        $user = self::findById($userId);

        if ($user === null) {
            return ['ok' => false, 'error' => 'Account not found.'];
        }

        if ($currentPassword === '') {
            return ['ok' => false, 'error' => 'Please enter your current password.'];
        }

        if (!self::verifyCredentials($user, $currentPassword)) {
            self::audit('auth.password.change.fail', 'Wrong current password for ' . $user['username'], $userId);
            return ['ok' => false, 'error' => 'Your current password is not correct.'];
        }

        if ((int) $user['must_change_password'] === 1 && self::tempPasswordExpired($user)) {
            return ['ok' => false, 'error' => 'This temporary password has expired. Ask an administrator to issue you a new one.'];
        }

        $problem = self::validateNewPassword($newPassword);

        if ($problem !== null) {
            return ['ok' => false, 'error' => $problem];
        }

        if (self::verifyCredentials($user, $newPassword)) {
            return ['ok' => false, 'error' => 'Your new password must be different from your current password.'];
        }

        Database::execute(
            'UPDATE users
                SET password_hash = ?,
                    legacy_password_hash = NULL,
                    must_change_password = 0,
                    temp_password_expires_at = NULL,
                    password_changed_at = NOW(),
                    failed_login_count = 0,
                    locked_until = NULL
              WHERE id = ?',
            [self::hashPassword($newPassword), $userId]
        );

        self::revokeOtherSessions($userId);

        if (session_status() === PHP_SESSION_ACTIVE && (int) ($_SESSION['user_id'] ?? 0) === $userId) {
            $csrf = Csrf::rotate();
            $rawToken = $_SESSION['auth_token'] ?? '';
            if (is_string($rawToken) && $rawToken !== '') {
                Database::execute(
                    'UPDATE sessions SET csrf_token = ? WHERE id = ?',
                    [$csrf, hash('sha256', $rawToken)]
                );
            }
        }

        self::audit('auth.password.change', 'Password changed for ' . $user['username'], $userId);

        return ['ok' => true];
    }

    public static function logoutUser(): void
    {
        if (session_status() === PHP_SESSION_ACTIVE) {
            $rawToken = $_SESSION['auth_token'] ?? '';
            $userId   = (int) ($_SESSION['user_id'] ?? 0);

            if (is_string($rawToken) && $rawToken !== '') {
                Database::execute('DELETE FROM sessions WHERE id = ?', [hash('sha256', $rawToken)]);
            }

            if ($userId > 0) {
                self::audit('auth.logout', 'Signed out', $userId);
            }
        }

        self::clearSession();
    }

    /** @param array<string, mixed> $user */
    public static function tempPasswordExpired(array $user): bool
    {
        if ((int) ($user['must_change_password'] ?? 0) !== 1) {
            return false;
        }

        $expires = $user['temp_password_expires_at'] ?? null;

        if (!is_string($expires) || $expires === '') {
            return false;
        }

        return strtotime($expires) !== false && strtotime($expires) < time();
    }

    public static function validateNewPassword(string $password): ?string
    {
        $minimum = (int) Config::get('security.password_min_length', 8);

        if (mb_strlen($password) < $minimum) {
            return 'Your new password must be at least ' . $minimum . ' characters long.';
        }

        if (!preg_match('/[A-Za-z]/', $password) || !preg_match('/[0-9]/', $password)) {
            return 'Your new password must contain at least one letter and one number.';
        }

        return null;
    }

    public static function generateTempPassword(): string
    {
        $chars = self::pick(self::LOWERS, 1)
            . self::pick(self::UPPERS, 1)
            . self::pick(self::DIGITS, 1)
            . self::pick(self::LOWERS . self::UPPERS . self::DIGITS, 9);

        $parts = str_split($chars);

        for ($i = count($parts) - 1; $i > 0; $i--) {
            $j = random_int(0, $i);
            [$parts[$i], $parts[$j]] = [$parts[$j], $parts[$i]];
        }

        return implode('', $parts);
    }

    /** Recovery answers are stored only as a bcrypt digest. */
    public static function hashRecoveryAnswer(string $answer): string
    {
        return password_hash(mb_strtolower(trim($answer)), PASSWORD_DEFAULT);
    }

    /** @param array<string, mixed> $user */
    public static function verifyRecoveryAnswer(array $user, string $answer): bool
    {
        $answer = trim($answer);

        if ($answer === '') {
            return false;
        }

        $normalised = mb_strtolower($answer);

        $hash = $user['recovery_answer_hash'] ?? null;

        if (is_string($hash) && $hash !== '' && password_verify($normalised, $hash)) {
            return true;
        }

        $legacy = $user['legacy_recovery_answer_hash'] ?? null;

        if (is_string($legacy) && $legacy !== '') {
            return hash_equals(strtolower($legacy), hash('sha256', $normalised));
        }

        return false;
    }

    public static function loginUrl(): string
    {
        return rtrim((string) Config::get('app.url', ''), '/') . '/admin/login.php';
    }

    public static function changePasswordUrl(): string
    {
        return rtrim((string) Config::get('app.url', ''), '/') . '/admin/password.php';
    }

    public static function clientIp(): string
    {
        $ip = $_SERVER['REMOTE_ADDR'] ?? '';
        return is_string($ip) ? substr($ip, 0, 45) : '';
    }

    public static function userAgent(): string
    {
        $agent = $_SERVER['HTTP_USER_AGENT'] ?? '';
        return is_string($agent) ? substr($agent, 0, 255) : '';
    }

    public static function audit(string $action, ?string $detail = null, ?int $userId = null): void
    {
        try {
            Database::execute(
                'INSERT INTO audit_log (user_id, action, detail, ip, user_agent, created_at)
                 VALUES (?, ?, ?, ?, ?, NOW())',
                [$userId, substr($action, 0, 100), $detail, self::clientIp(), self::userAgent()]
            );
        } catch (\Throwable $e) {
            error_log('Audit log write failed: ' . $e->getMessage());
        }
    }

    /** @param array<string, mixed> $user */
    private static function upgradePasswordHash(array $user, string $password): void
    {
        $hash = $user['password_hash'] ?? null;

        $needsUpgrade = !is_string($hash)
            || $hash === ''
            || password_needs_rehash($hash, PASSWORD_DEFAULT)
            || !empty($user['legacy_password_hash']);

        if ($needsUpgrade) {
            Database::execute(
                'UPDATE users SET password_hash = ?, legacy_password_hash = NULL WHERE id = ?',
                [self::hashPassword($password), (int) $user['id']]
            );
        }
    }

    /** @param array<string, mixed> $user */
    private static function recordFailure(array $user): void
    {
        $id = (int) $user['id'];
        $max = (int) Config::get('security.max_login_attempts', 5);
        $minutes = (int) Config::get('security.lockout_minutes', 15);

        Database::execute('UPDATE users SET failed_login_count = failed_login_count + 1 WHERE id = ?', [$id]);

        $count = (int) Database::value('SELECT failed_login_count FROM users WHERE id = ?', [$id]);

        if ($count >= $max) {
            $until = date('Y-m-d H:i:s', time() + $minutes * 60);
            Database::execute('UPDATE users SET locked_until = ? WHERE id = ?', [$until, $id]);
        }
    }

    /** @param array<string, mixed> $user */
    private static function lockedUntilActive(array $user): bool
    {
        $until = $user['locked_until'] ?? null;
        return is_string($until) && $until !== '' && strtotime($until) !== false && strtotime($until) > time();
    }

    private static function tooManyRecentFailures(string $username, string $ip): bool
    {
        $max = (int) Config::get('security.max_login_attempts', 5);
        $minutes = (int) Config::get('security.lockout_minutes', 15);
        $since = date('Y-m-d H:i:s', time() - $minutes * 60);

        $count = (int) Database::value(
            'SELECT COUNT(*) FROM login_attempts
              WHERE success = 0
                AND attempted_at >= ?
                AND (username = ? OR ip = ?)',
            [$since, $username, $ip]
        );

        return $count >= $max;
    }

    private static function logAttempt(string $username, string $ip, bool $success): void
    {
        try {
            Database::execute(
                'INSERT INTO login_attempts (username, ip, success, attempted_at) VALUES (?, ?, ?, NOW())',
                [substr($username, 0, 64), $ip, $success ? 1 : 0]
            );
        } catch (\Throwable $e) {
            error_log('Login attempt log failed: ' . $e->getMessage());
        }
    }

    private static function revokeOtherSessions(int $userId): void
    {
        if (session_status() !== PHP_SESSION_ACTIVE) {
            Database::execute('DELETE FROM sessions WHERE user_id = ?', [$userId]);
            return;
        }

        $rawToken = $_SESSION['auth_token'] ?? '';

        if (is_string($rawToken) && $rawToken !== '') {
            Database::execute('DELETE FROM sessions WHERE user_id = ? AND id <> ?', [$userId, hash('sha256', $rawToken)]);
        } else {
            Database::execute('DELETE FROM sessions WHERE user_id = ?', [$userId]);
        }
    }

    private static function clearSession(): void
    {
        if (session_status() !== PHP_SESSION_ACTIVE) {
            return;
        }

        $_SESSION = [];

        if (ini_get('session.use_cookies')) {
            $params = session_get_cookie_params();
            setcookie(session_name(), '', [
                'expires'  => time() - 42000,
                'path'     => $params['path'],
                'domain'   => $params['domain'],
                'secure'   => (bool) $params['secure'],
                'httponly' => (bool) $params['httponly'],
                'samesite' => $params['samesite'] ?? 'Lax',
            ]);
        }

        session_destroy();
    }

    private static function pick(string $set, int $length): string
    {
        $out = '';
        $max = strlen($set) - 1;

        for ($i = 0; $i < $length; $i++) {
            $out .= $set[random_int(0, $max)];
        }

        return $out;
    }
}
