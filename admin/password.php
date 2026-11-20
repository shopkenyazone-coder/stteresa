<?php
declare(strict_types=1);

require __DIR__ . '/../src/bootstrap.php';

use STA\Auth;
use STA\Csrf;

$roleHomes = [
    'admin'          => '../admin/dashboard.php',
    'director'       => '../admin/dashboard.php',
    'headteacher'    => '../headteacher/dashboard.php',
    'chiefexaminer'  => '../chiefexaminer/dashboard.php',
    'secretary'      => '../secretary/dashboard.php',
    'teacher'        => '../teacher/dashboard.php',
    'storekeeper'    => '../store/dashboard.php',
    'uniformstaff'   => '../store/dashboard.php',
    'kitchenmanager' => '../kitchen/dashboard.php',
    'student'        => '../student/dashboard.php',
];

$roleLabels = [
    'admin'          => 'Admin',
    'director'       => 'Director',
    'headteacher'    => 'Headteacher',
    'chiefexaminer'  => 'Chief Examiner',
    'secretary'      => 'Secretary',
    'teacher'        => 'Teacher',
    'storekeeper'    => 'Stores',
    'uniformstaff'   => 'Uniforms',
    'kitchenmanager' => 'Kitchen',
    'student'        => 'Student',
];

$user = Auth::currentUser();

if ($user === null) {
    sta_redirect('login.php');
}

$expired = Auth::tempPasswordExpired($user);
$isTemporary = (int) $user['must_change_password'] === 1;
$error = '';

if (!$expired && sta_is_post()) {
    $token = sta_post_string('csrf_token');
    $currentPassword = isset($_POST['currentPassword']) && is_string($_POST['currentPassword']) ? $_POST['currentPassword'] : '';
    $newPassword = isset($_POST['newPassword']) && is_string($_POST['newPassword']) ? $_POST['newPassword'] : '';
    $confirmPassword = isset($_POST['confirmPassword']) && is_string($_POST['confirmPassword']) ? $_POST['confirmPassword'] : '';

    if (!Csrf::validate($token)) {
        $error = 'Your session has expired. Please try again.';
    } elseif ($newPassword !== $confirmPassword) {
        $error = 'The two passwords do not match.';
    } else {
        $result = Auth::changePassword((int) $user['id'], $currentPassword, $newPassword);

        if ($result['ok']) {
            sta_redirect($roleHomes[$user['role']] ?? '../admin/dashboard.php');
        }

        $error = $result['error'] ?? 'Your password could not be changed.';
    }
}

$csrfToken = Csrf::token();
$displayName = (string) ($user['name'] ?: $user['username']);
$roleLabel = $roleLabels[$user['role']] ?? ucfirst((string) $user['role']);
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="icon" type="image/svg+xml" href="../images/favicon.svg">
  <title>Set New Password | St. Teresa Academy Portals</title>
  <link rel="stylesheet" href="../css/admin.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body data-page="password" class="login-page">

  <main class="login-card">

    <header class="login-brand">
      <img class="login-crest" src="../images/favicon.svg" width="52" height="52" alt="St. Teresa Kanyange Academy crest">
      <div class="login-brand-text">
        <h1>St. Teresa Kanyange Academy</h1>
        <p>Set New Password</p>
      </div>
    </header>

    <p class="account-note">
      Signed in as <strong id="changeName"><?= sta_e($displayName) ?></strong>
      <span class="badge badge-navy" id="changeRole"><?= sta_e($roleLabel) ?></span>
      <br><small id="changeHint"><?= $isTemporary ? 'Enter the temporary password you were given as your current password, then choose a new one of your own.' : 'Enter your current password, then choose a new one.' ?></small>
    </p>

    <div class="change-banner<?= $expired ? ' danger' : ($isTemporary ? ' warn' : '') ?>" id="tempBanner">
      <?php if ($expired): ?>
        <i class="fas fa-triangle-exclamation" aria-hidden="true"></i> This temporary password has expired. Ask an administrator to issue you a new one.
        <button type="button" class="link-btn" id="bannerSignOut">Sign out</button>
      <?php elseif ($isTemporary): ?>
        <i class="fas fa-key" aria-hidden="true"></i> You are signing in with a temporary password. Set your own password now.
      <?php else: ?>
        <i class="fas fa-shield-halved" aria-hidden="true"></i> For your security, confirm your current password before setting a new one.
      <?php endif; ?>
    </div>

    <div class="login-error<?= $error !== '' ? ' show' : '' ?>" id="changeError" role="alert"><?= sta_e($error) ?></div>

    <form class="login-form" id="changeForm" method="post" action="password.php" novalidate<?= $expired ? ' style="display:none"' : '' ?>>
      <input type="hidden" name="csrf_token" value="<?= sta_e($csrfToken) ?>">
      <div class="form-group" id="currentPasswordGroup">
        <label for="currentPassword">Current Password</label>
        <input type="password" id="currentPassword" name="currentPassword" placeholder="Enter your current password"
          autocomplete="current-password" required>
        <small class="field-hint"><?= $isTemporary ? 'Use the temporary password you were given.' : 'Your current password is required.' ?></small>
      </div>
      <div class="form-group">
        <label for="newPassword">New Password</label>
        <input type="password" id="newPassword" name="newPassword" placeholder="Enter new password" autocomplete="new-password" minlength="8" required>
        <div class="pw-meter" id="pwMeter" data-score="0"><i></i></div>
        <small class="pw-meter-text" id="pwMeterText">At least 8 characters, one letter and one number.</small>
      </div>
      <div class="form-group">
        <label for="confirmPassword">Confirm Password</label>
        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Re-enter new password" autocomplete="new-password" minlength="8" required>
      </div>
      <button type="submit" class="login-btn"><i class="fas fa-key" aria-hidden="true"></i>&nbsp; Save Password &amp; Continue</button>
    </form>

    <a href="#" class="login-back" id="changeCancel"><i class="fas fa-right-from-bracket" aria-hidden="true"></i> Sign out instead</a>

    <p class="login-credit">Powered by <span class="pby-dot">&#9670;</span> <a href="https://shopixhub.co.ke/" target="_blank" rel="noopener" title="Visit SHOPIX HUB SOLUTION website"><strong>SHOPIX HUB SOLUTION</strong></a></p>

  </main>

  <script>
  (function () {
    'use strict';
    var csrf = <?= json_encode($csrfToken) ?>;
    var root = new URL('../', document.baseURI).href;

    function signOut(e) {
      if (e) e.preventDefault();
      try {
        var xhr = new XMLHttpRequest();
        xhr.open('POST', new URL('api/logout.php', root).href, false);
        xhr.setRequestHeader('X-CSRF-Token', csrf);
        xhr.send(null);
      } catch (err) { /* ignore */ }
      window.location.href = 'login.php';
    }

    var cancel = document.getElementById('changeCancel');
    if (cancel) cancel.addEventListener('click', signOut);
    var bannerOut = document.getElementById('bannerSignOut');
    if (bannerOut) bannerOut.addEventListener('click', signOut);

    var pw = document.getElementById('newPassword');
    var meter = document.getElementById('pwMeter');
    var meterTxt = document.getElementById('pwMeterText');
    var labels = ['Too short', 'Weak', 'Fair', 'Good', 'Strong'];
    var classes = ['bad', 'bad', 'warn', 'ok', 'ok'];
    function scoreOf(v) {
      if (!v) return -1;
      var n = 0;
      if (v.length >= 8) n++;
      if (v.length >= 12) n++;
      if (/[A-Za-z]/.test(v) && /[0-9]/.test(v)) n++;
      if (/[^A-Za-z0-9]/.test(v)) n++;
      if (v.length >= 16) n++;
      return Math.min(n, 4);
    }
    if (pw && meter && meterTxt) {
      pw.addEventListener('input', function () {
        var v = pw.value, n = scoreOf(v);
        meter.className = 'pw-meter';
        if (n < 0) {
          meterTxt.textContent = 'At least 8 characters, one letter and one number.';
          meterTxt.className = 'pw-meter-text';
          return;
        }
        meter.classList.add('on');
        meter.setAttribute('data-score', n);
        meter.style.setProperty('--pct', ((n + 1) / 5 * 100) + '%');
        meterTxt.textContent = labels[n];
        meterTxt.className = 'pw-meter-text ' + classes[n];
      });
    }
  })();
  </script>
  <script src="../js/persist.js"></script>
  <script src="../js/auth-bridge.js"></script>
  <script src="../js/admin.js"></script>
  <script src="../js/security.js"></script>
  <script src="../js/modules.js"></script>
  <script src="../js/settings.js"></script>
</body>
</html>
