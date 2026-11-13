/* ============================================================
   SERVER AUTH BRIDGE
   Loaded after persist.js and before admin.js on portal pages.

   The existing portal JavaScript reads its session from
   sessionStorage. This bridge fills that session from the real
   PHP session so all pages agree with the server, without
   changing the rest of the portal code.
   ============================================================ */
(function () {
  'use strict';

  var script = document.currentScript;
  var scriptURL = script && script.src
    ? new URL(script.src, document.baseURI)
    : new URL('js/auth-bridge.js', document.baseURI);
  var root = new URL('../', scriptURL);
  var endpoint = new URL('api/session.php', root).href;

  window.STA_ROOT_URL = root.href;
  window.STA_SERVER_AUTH = false;
  window.STA_SERVER_CSRF = '';

  function serverSession() {
    try {
      var xhr = new XMLHttpRequest();
      xhr.open('GET', endpoint + '?t=' + Date.now(), false);
      xhr.setRequestHeader('Accept', 'application/json');
      xhr.send(null);
      if (xhr.status !== 200) return null;
      var res = JSON.parse(xhr.responseText);
      if (!res || !res.ok || !res.authenticated || !res.user) return null;
      return res;
    } catch (e) {
      return null;
    }
  }

  function localUsers() {
    try {
      var list = JSON.parse(localStorage.getItem('sta_users') || '[]');
      return Array.isArray(list) ? list : [];
    } catch (e) {
      return [];
    }
  }

  function findLocalId(user) {
    var users = localUsers();
    var username = String(user.username || '').toLowerCase();
    var i;

    for (i = 0; i < users.length; i++) {
      if (String(users[i] && users[i].username || '').toLowerCase() === username) return users[i].id;
    }

    if (user.legacyId) {
      for (i = 0; i < users.length; i++) {
        if (String(users[i] && users[i].legacyId || '') === String(user.legacyId)) return users[i].id;
      }
    }

    for (i = 0; i < users.length; i++) {
      if (String(users[i] && users[i].id || '') === String(user.id)) return users[i].id;
    }

    return user.id;
  }

  var res = serverSession();

  if (!res) {
    try { sessionStorage.removeItem('sta_session'); } catch (e) { /* ignore */ }
    return;
  }

  var user = res.user;
  var session = {
    id: findLocalId(user),
    serverId: user.id,
    role: user.role,
    name: user.name || user.username,
    username: user.username,
    email: user.email || '',
    phone: user.phone || '',
    subject: user.subject || '',
    grade: user.grade || '',
    className: user.className || '',
    photo: user.photo || '',
    mustChangePassword: !!user.mustChangePassword,
    tempPasswordExpired: !!user.tempPasswordExpired,
    issuedAt: new Date().toISOString()
  };

  window.STA_SERVER_AUTH = true;
  window.STA_SERVER_CSRF = String(res.csrfToken || '');
  window.STA_SERVER_USER = user;

  try {
    sessionStorage.setItem('sta_session', JSON.stringify(session));
  } catch (e) { /* ignore */ }
})();
