<?php

declare(strict_types=1);

/**
 * Stage 1 smoke test. Run from the project root:
 *
 *   php tests/php/smoke.php
 *
 * Verifies configuration, database connectivity, password hashing,
 * legacy PBKDF2 compatibility, password policy and CSRF tokens.
 */

if (PHP_SAPI !== 'cli') {
    http_response_code(403);
    exit("CLI only.\n");
}

require dirname(__DIR__, 2) . '/src/bootstrap.php';

use STA\Auth;
use STA\Config;
use STA\Csrf;
use STA\Database;

$passed = 0;
$failed = 0;

function check(string $name, bool $condition, string $detail = ''): void
{
    global $passed, $failed;

    if ($condition) {
        $passed++;
        echo "PASS  {$name}\n";
    } else {
        $failed++;
        echo "FAIL  {$name}" . ($detail !== '' ? " ({$detail})" : '') . "\n";
    }
}

echo "Stage 1 smoke test\n";
echo str_repeat('-', 60) . "\n";

check('config loads application name', Config::get('app.name') === 'St. Teresa Kanyange Academy');
check('database name is configured', is_string(Config::get('db.name')) && Config::get('db.name') !== '');

try {
    $version = (string) Database::value('SELECT VERSION()');
    check('database connection works', $version !== '', $version);
} catch (Throwable $e) {
    check('database connection works', false, $e->getMessage());
    echo "\nStopped: import database/schema.sql and run database/seed.php first.\n";
    exit(1);
}

$tables = ['users', 'sessions', 'login_attempts', 'audit_log', 'contact_messages', 'media', 'import_staging', 'import_runs'];

foreach ($tables as $table) {
    $found = Database::value(
        'SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = ?',
        [$table]
    );

    check("table exists: {$table}", (int) $found === 1);
}

$admin = Auth::findByUsername('admin');

check('demo admin account exists', $admin !== null);

if ($admin !== null) {
    check('demo admin password verifies', Auth::verifyCredentials($admin, 'admin123'));
    check('wrong demo password is refused', !Auth::verifyCredentials($admin, 'wrong-password'));
    check('admin role is correct', $admin['role'] === 'admin');
    check('demo account is marked is_demo', (int) $admin['is_demo'] === 1);
}

$plain = 'LegacyPass123';
$iterations = 50000;
$salt = random_bytes(16);
$digest = hash_pbkdf2('sha256', $plain, $salt, $iterations, 32, true);
$legacyHash = 'pbkdf2$' . $iterations . '$' . base64_encode($salt) . '$' . base64_encode($digest);

check('legacy PBKDF2 hash verifies', Auth::verifyLegacyPbkdf2($plain, $legacyHash));
check('legacy PBKDF2 rejects wrong password', !Auth::verifyLegacyPbkdf2('nope', $legacyHash));
check('legacy PBKDF2 rejects malformed hash', !Auth::verifyLegacyPbkdf2($plain, 'not-a-hash'));

$bcrypt = Auth::hashPassword('CorrectHorse9');
check('bcrypt hash verifies', password_verify('CorrectHorse9', $bcrypt));
check('bcrypt hash is not plain text', $bcrypt !== 'CorrectHorse9');

check('password policy accepts valid password', Auth::validateNewPassword('ValidPass1') === null);
check('password policy rejects short password', Auth::validateNewPassword('Ab1') !== null);
check('password policy rejects letters only', Auth::validateNewPassword('onlyletters') !== null);
check('password policy rejects numbers only', Auth::validateNewPassword('12345678') !== null);

$token = Csrf::token();
check('CSRF token is generated', strlen($token) === 64);
check('CSRF token validates', Csrf::validate($token));
check('CSRF token rejects wrong value', !Csrf::validate(str_repeat('a', 64)));
check('CSRF token rejects empty value', !Csrf::validate(''));

$rotated = Csrf::rotate();
check('CSRF token rotates', $rotated !== $token && Csrf::validate($rotated));

$temp = Auth::generateTempPassword();
check('temporary password has 12 characters', mb_strlen($temp) === 12);
check('temporary password contains a digit', preg_match('/[0-9]/', $temp) === 1);
check('temporary password passes policy', Auth::validateNewPassword($temp) === null);

echo str_repeat('-', 60) . "\n";
echo "Result: {$passed} passed, {$failed} failed\n";

exit($failed === 0 ? 0 : 1);
