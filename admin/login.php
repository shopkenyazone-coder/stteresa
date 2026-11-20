<?php
declare(strict_types=1);

require __DIR__ . '/../src/bootstrap.php';

use STA\Auth;
use STA\Csrf;

$portalHomes = [
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

$validPortalRoles = [
    'admin', 'headteacher', 'chiefexaminer', 'secretary',
    'teacher', 'storekeeper', 'kitchenmanager', 'student',
];

$current = Auth::currentUser();

if ($current !== null) {
    if ((int) $current['must_change_password'] === 1) {
        sta_redirect('../admin/password.php');
    }
    sta_redirect($portalHomes[$current['role']] ?? '../admin/dashboard.php');
}

$error = '';
$retryAfter = 0;
$username = '';
$portalRole = sta_get_string('role', 'admin');

if (!in_array($portalRole, $validPortalRoles, true)) {
    $portalRole = 'admin';
}

if (sta_is_post()) {
    $username = sta_post_string('username');
    $password = isset($_POST['password']) && is_string($_POST['password']) ? $_POST['password'] : '';
    $submittedRole = sta_post_string('portalRole', 'admin');
    $portalRole = in_array($submittedRole, $validPortalRoles, true) ? $submittedRole : 'admin';
    $token = sta_post_string('csrf_token');

    if (!Csrf::validate($token)) {
        $error = 'Your session has expired. Please try again.';
    } else {
        $result = Auth::attempt($username, $password, $portalRole);

        if ($result['ok']) {
            Auth::loginUser($result['user']);
            $user = $result['user'];

            if ((int) $user['must_change_password'] === 1) {
                sta_redirect('../admin/password.php');
            }

            sta_redirect($portalHomes[$user['role']] ?? '../admin/dashboard.php');
        }

        $retryAfter = (int) ($result['retry_after'] ?? 0);
        $error = $result['error'] ?? 'Invalid username or password. Please try again.';
    }
}

$csrfToken = Csrf::token();
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="icon" type="image/svg+xml" href="../images/favicon.svg">
  <title>Login | St. Teresa Academy Portals</title>
  <link rel="stylesheet" href="../css/admin.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body data-page="login" class="login-page">

  <main class="login-card">

    <header class="login-brand">
      <img class="login-crest" src="../images/favicon.svg" width="52" height="52" alt="St. Teresa Kanyange Academy crest">
      <div class="login-brand-text">
        <h1>St. Teresa Kanyange Academy</h1>
        <p>Portal Login</p>
      </div>
    </header>

    <div class="role-tabs" role="group" aria-label="Choose your portal">
      <button type="button" class="role-tab<?= $portalRole === 'admin' ? ' active' : '' ?>" data-role="admin" aria-pressed="<?= $portalRole === 'admin' ? 'true' : 'false' ?>">
        <i class="fas fa-user-shield" aria-hidden="true"></i> Admin
      </button>
      <button type="button" class="role-tab<?= $portalRole === 'headteacher' ? ' active' : '' ?>" data-role="headteacher" aria-pressed="<?= $portalRole === 'headteacher' ? 'true' : 'false' ?>">
        <i class="fas fa-school" aria-hidden="true"></i> Headteacher
      </button>
      <button type="button" class="role-tab<?= $portalRole === 'chiefexaminer' ? ' active' : '' ?>" data-role="chiefexaminer" aria-pressed="<?= $portalRole === 'chiefexaminer' ? 'true' : 'false' ?>">
        <i class="fas fa-user-tie" aria-hidden="true"></i> Chief Examiner
      </button>
      <button type="button" class="role-tab<?= $portalRole === 'secretary' ? ' active' : '' ?>" data-role="secretary" aria-pressed="<?= $portalRole === 'secretary' ? 'true' : 'false' ?>">
        <i class="fas fa-id-card" aria-hidden="true"></i> Secretary
      </button>
      <button type="button" class="role-tab<?= $portalRole === 'teacher' ? ' active' : '' ?>" data-role="teacher" aria-pressed="<?= $portalRole === 'teacher' ? 'true' : 'false' ?>">
        <i class="fas fa-chalkboard-teacher" aria-hidden="true"></i> Teacher
      </button>
      <button type="button" class="role-tab<?= $portalRole === 'storekeeper' ? ' active' : '' ?>" data-role="storekeeper" aria-pressed="<?= $portalRole === 'storekeeper' ? 'true' : 'false' ?>">
        <i class="fas fa-warehouse" aria-hidden="true"></i> Stores
      </button>
      <button type="button" class="role-tab<?= $portalRole === 'kitchenmanager' ? ' active' : '' ?>" data-role="kitchenmanager" aria-pressed="<?= $portalRole === 'kitchenmanager' ? 'true' : 'false' ?>">
        <i class="fas fa-utensils" aria-hidden="true"></i> Kitchen
      </button>
      <button type="button" class="role-tab<?= $portalRole === 'student' ? ' active' : '' ?>" data-role="student" aria-pressed="<?= $portalRole === 'student' ? 'true' : 'false' ?>">
        <i class="fas fa-user-graduate" aria-hidden="true"></i> Student
      </button>
    </div>

    <div class="login-error<?= $error !== '' ? ' show' : '' ?>" id="loginError" role="alert" data-retry-after="<?= $retryAfter ?>"><?= sta_e($error) ?></div>

    <form class="login-form" id="loginForm" method="post" action="login.php" novalidate>
      <input type="hidden" name="csrf_token" value="<?= sta_e($csrfToken) ?>">
      <input type="hidden" name="portalRole" id="portalRole" value="<?= sta_e($portalRole) ?>">
      <div class="form-group">
        <label for="username">Username</label>
        <input type="text" id="username" name="username" value="<?= sta_e($username) ?>" placeholder="Enter username" autocomplete="username" autocapitalize="none"
          spellcheck="false" required>
      </div>
      <div class="form-group">
        <label for="password">Password</label>
        <input type="password" id="password" name="password" placeholder="Enter password" autocomplete="current-password" required>
      </div>
      <button type="submit" class="login-btn"><i class="fas fa-right-to-bracket" aria-hidden="true"></i>&nbsp; Sign In</button>
    </form>

    <a href="../index.php" class="login-back"><i class="fas fa-arrow-left" aria-hidden="true"></i> Back to School Website</a>

    <p class="login-credit">Powered by <span class="pby-dot">&#9670;</span> <a href="https://shopixhub.co.ke/" target="_blank" rel="noopener" title="Visit SHOPIX HUB SOLUTION website"><strong>SHOPIX HUB SOLUTION</strong></a></p>

  </main>

  <script>
  (function () {
    'use strict';
    var usernames = {
      admin: 'admin', headteacher: 'headteacher', chiefexaminer: 'chiefexaminer',
      secretary: 'secretary', teacher: 'teacher', storekeeper: 'storekeeper',
      kitchenmanager: 'kitchenmanager', student: 'student'
    };
    var tabs = document.querySelectorAll('.role-tab');
    var hidden = document.getElementById('portalRole');
    var uname = document.getElementById('username');
    var pass = document.getElementById('password');
    var err = document.getElementById('loginError');

    var retryAfter = err ? parseInt(err.getAttribute('data-retry-after') || '0', 10) : 0;

    if (err && retryAfter > 0) {
      var countdown = retryAfter;
      var timer = window.setInterval(function () {
        countdown -= 1;

        if (countdown <= 0) {
          window.clearInterval(timer);
          err.textContent = 'You can try again now.';
          return;
        }

        err.textContent = 'Too many failed attempts. Please wait ' + countdown + ' seconds and try again.';
      }, 1000);
    }

    tabs.forEach(function (tab) {
      tab.addEventListener('click', function () {
        tabs.forEach(function (t) {
          t.classList.remove('active');
          t.setAttribute('aria-pressed', 'false');
        });
        tab.classList.add('active');
        tab.setAttribute('aria-pressed', 'true');
        var role = tab.dataset.role;
        if (hidden) hidden.value = role;
        if (uname) uname.value = usernames[role] || '';
        if (pass) pass.value = '';
        if (err) err.classList.remove('show');
      });
    });

    var preset = new URLSearchParams(window.location.search).get('role');
    if (preset) {
      var chosen = document.querySelector('.role-tab[data-role="' + preset + '"]');
      if (chosen) chosen.click();
    }
  })();
  </script>
  <script src="../js/persist.js"></script>
  <script src="../js/auth-bridge.js"></script>
  <script src="../js/admin.js"></script>
  <script src="../js/security.js"></script>
</body>
</html>
