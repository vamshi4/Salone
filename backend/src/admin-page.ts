// Super-admin dashboard served at GET /admin. The page itself is public HTML,
// but every API call it makes requires a SUPER_ADMIN token, so it shows nothing
// until you sign in. Embedded as a string so it ships inside the compiled
// bundle with no static-file copy step (same approach as privacy.ts).
export const adminPageHtml = `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Chairful — Admin</title>
<style>
  :root { --ink:#0F172A; --muted:#5B6B66; --accent:#0E7C6B; --border:#ECEEF1; --bg:#F7F8FA; }
  * { box-sizing:border-box; }
  body { margin:0; background:var(--bg); color:var(--ink);
    font-family:system-ui,-apple-system,"Segoe UI",Roboto,sans-serif; }
  header { background:#fff; border-bottom:1px solid var(--border); padding:14px 22px;
    display:flex; align-items:center; justify-content:space-between; }
  h1 { font-size:19px; margin:0; letter-spacing:-.01em; }
  .wrap { max-width:1180px; margin:0 auto; padding:24px 18px 70px; }
  button { font:inherit; cursor:pointer; border-radius:8px; border:1px solid var(--accent);
    background:var(--accent); color:#fff; padding:9px 15px; }
  button.ghost { background:#fff; color:var(--accent); }
  input { font:inherit; padding:11px 12px; border:1px solid var(--border);
    border-radius:8px; width:100%; background:#fff; }
  .login { max-width:360px; margin:70px auto; background:#fff; padding:26px;
    border:1px solid var(--border); border-radius:14px; }
  .login h2 { margin:0 0 4px; font-size:22px; }
  .login p { color:var(--muted); margin:0 0 18px; font-size:14px; }
  .login label { display:block; font-size:13px; color:var(--muted); margin:12px 0 5px; }
  .err { color:#B4232B; font-size:13.5px; margin-top:12px; min-height:18px; }
  .kpis { display:grid; grid-template-columns:repeat(auto-fit,minmax(160px,1fr)); gap:12px; }
  .kpi { background:#fff; border:1px solid var(--border); border-radius:12px; padding:15px 16px; }
  .kpi .n { font-size:26px; font-weight:600; letter-spacing:-.02em; }
  .kpi .l { font-size:12.5px; color:var(--muted); margin-top:3px; }
  .kpi.warn .n { color:#B4232B; }
  .card { background:#fff; border:1px solid var(--border); border-radius:12px;
    padding:18px; margin-top:20px; }
  .card h3 { margin:0 0 14px; font-size:15px; }
  .scroll { overflow-x:auto; }
  table { border-collapse:collapse; width:100%; font-size:14px; }
  th,td { border-bottom:1px solid var(--border); padding:9px 10px; text-align:left; white-space:nowrap; }
  th { color:var(--muted); font-weight:500; font-size:12.5px; }
  tbody tr:hover { background:#F7FBFA; cursor:pointer; }
  .pill { display:inline-block; padding:2px 8px; border-radius:20px; font-size:12px;
    background:#EEF5F3; color:var(--accent); }
  .pill.dim { background:#F1F2F4; color:var(--muted); }
  .hidden { display:none; }
  .legend { font-size:12.5px; color:var(--muted); margin-top:8px; }
  .sw { display:inline-block; width:9px; height:9px; border-radius:2px; margin-right:5px; }
  .muted { color:var(--muted); }
</style>
</head>
<body>

<div id="loginView">
  <div class="login">
    <h2>Chairful Admin</h2>
    <p>Sign in with a super-admin account.</p>
    <label for="phone">Phone</label>
    <input id="phone" type="tel" autocomplete="username">
    <label for="password">Password</label>
    <input id="password" type="password" autocomplete="current-password">
    <div class="err" id="loginErr"></div>
    <button id="loginBtn" style="width:100%;margin-top:6px">Sign in</button>
  </div>
</div>

<div id="appView" class="hidden">
  <header>
    <h1>Chairful <span class="muted" style="font-weight:400">· Admin</span></h1>
    <button class="ghost" id="logoutBtn">Sign out</button>
  </header>
  <div class="wrap">
    <div class="kpis" id="kpis"></div>

    <div class="card">
      <h3>Last 30 days</h3>
      <div id="chart"></div>
      <div class="legend">
        <span><i class="sw" style="background:#0E7C6B"></i>Bookings</span>
        &nbsp;&nbsp;
        <span><i class="sw" style="background:#C9A227"></i>New salon signups</span>
      </div>
    </div>

    <div class="card">
      <h3>Salons</h3>
      <div class="scroll">
        <table>
          <thead><tr>
            <th>Salon</th><th>Owner</th><th>Phone</th><th>Plan</th>
            <th>Bookings</th><th>Customers</th><th>Staff</th>
            <th>Signed up</th><th>Last booking</th>
          </tr></thead>
          <tbody id="salonRows"></tbody>
        </table>
      </div>
    </div>

    <div class="card hidden" id="detailCard">
      <h3 id="detailTitle">Salon</h3>
      <div class="scroll">
        <table>
          <thead><tr><th>When</th><th>Customer</th><th>Service</th><th>Status</th><th>Price</th></tr></thead>
          <tbody id="detailRows"></tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<script>
(function () {
  var TOKEN_KEY = 'chairful_admin_token';
  var $ = function (id) { return document.getElementById(id); };

  function esc(value) {
    if (value === null || value === undefined) return '';
    return String(value)
      .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;').replace(/'/g, '&#39;');
  }
  function fmtDate(value) {
    if (!value) return '-';
    return new Date(value).toLocaleDateString('en-IN', { day: 'numeric', month: 'short', year: 'numeric' });
  }
  function fmtDateTime(value) {
    if (!value) return '-';
    return new Date(value).toLocaleString('en-IN', { dateStyle: 'medium', timeStyle: 'short' });
  }

  function token() { return localStorage.getItem(TOKEN_KEY); }
  function setToken(t) { localStorage.setItem(TOKEN_KEY, t); }
  function clearToken() { localStorage.removeItem(TOKEN_KEY); }

  function showLogin(message) {
    $('appView').classList.add('hidden');
    $('loginView').classList.remove('hidden');
    $('loginErr').textContent = message || '';
  }
  function showApp() {
    $('loginView').classList.add('hidden');
    $('appView').classList.remove('hidden');
  }

  function api(path) {
    return fetch('/api/v2/admin' + path, {
      headers: { Authorization: 'Bearer ' + token() }
    }).then(function (r) {
      if (r.status === 401 || r.status === 403) {
        clearToken();
        showLogin('Session expired. Please sign in again.');
        throw new Error('unauthorized');
      }
      if (!r.ok) throw new Error('Request failed (' + r.status + ')');
      return r.json();
    });
  }

  function kpi(n, label, warn) {
    return '<div class="kpi' + (warn ? ' warn' : '') + '">' +
      '<div class="n">' + esc(n) + '</div><div class="l">' + esc(label) + '</div></div>';
  }

  function renderStats(s) {
    $('kpis').innerHTML = [
      kpi(s.salons, 'Salons'),
      kpi(s.activeSalons, 'Active (30d)'),
      kpi(s.dormantSalons, 'Dormant (no booking 30d)', s.dormantSalons > 0),
      kpi(s.newSalons7, 'New signups (7d)'),
      kpi(s.newSalons30, 'New signups (30d)'),
      kpi(s.bookings, 'Bookings (all time)'),
      kpi(s.bookings30, 'Bookings (30d)'),
      kpi(s.customers, 'Customers')
    ].join('');
  }

  function renderChart(rows) {
    var w = 1100, h = 120, pad = 2;
    var max = 1;
    rows.forEach(function (r) {
      if (r.bookings > max) max = r.bookings;
      if (r.signups > max) max = r.signups;
    });
    var bw = w / rows.length;
    var bars = rows.map(function (r, i) {
      var x = i * bw;
      var bh = Math.round((r.bookings / max) * (h - 10));
      var sh = Math.round((r.signups / max) * (h - 10));
      var out = '<rect x="' + (x + pad) + '" y="' + (h - bh) + '" width="' + Math.max(bw - pad * 2, 1) +
        '" height="' + bh + '" fill="#0E7C6B" rx="1"><title>' + esc(r.date) + ': ' +
        r.bookings + ' bookings</title></rect>';
      if (r.signups > 0) {
        out += '<rect x="' + (x + pad) + '" y="' + (h - sh) + '" width="' + Math.max(bw - pad * 2, 1) +
          '" height="' + sh + '" fill="#C9A227" rx="1" opacity="0.85"><title>' + esc(r.date) + ': ' +
          r.signups + ' signups</title></rect>';
      }
      return out;
    }).join('');
    $('chart').innerHTML =
      '<svg viewBox="0 0 ' + w + ' ' + h + '" preserveAspectRatio="none" ' +
      'style="width:100%;height:120px">' + bars + '</svg>';
  }

  function planPill(plan) {
    var dim = String(plan).toUpperCase() === 'FREE' ? ' dim' : '';
    return '<span class="pill' + dim + '">' + esc(plan) + '</span>';
  }

  function renderSalons(rows) {
    if (!rows.length) {
      $('salonRows').innerHTML = '<tr><td colspan="9" class="muted">No salons yet.</td></tr>';
      return;
    }
    $('salonRows').innerHTML = rows.map(function (r) {
      return '<tr data-id="' + esc(r.id) + '">' +
        '<td>' + esc(r.name) + '</td>' +
        '<td>' + esc(r.ownerName || '-') + '</td>' +
        '<td>' + esc(r.ownerPhone) + '</td>' +
        '<td>' + planPill(r.saasPlan) + '</td>' +
        '<td>' + esc(r.bookings) + '</td>' +
        '<td>' + esc(r.customers) + '</td>' +
        '<td>' + esc(r.stylists) + '</td>' +
        '<td>' + fmtDate(r.signedUpAt) + '</td>' +
        '<td>' + fmtDate(r.lastBookingAt) + '</td>' +
        '</tr>';
    }).join('');

    Array.prototype.forEach.call($('salonRows').querySelectorAll('tr[data-id]'), function (tr) {
      tr.addEventListener('click', function () { loadDetail(tr.getAttribute('data-id')); });
    });
  }

  function loadDetail(id) {
    api('/salons/' + encodeURIComponent(id)).then(function (data) {
      $('detailCard').classList.remove('hidden');
      $('detailTitle').textContent = data.salon.name + ' - recent bookings';
      if (!data.bookings.length) {
        $('detailRows').innerHTML = '<tr><td colspan="5" class="muted">No bookings yet.</td></tr>';
      } else {
        $('detailRows').innerHTML = data.bookings.map(function (b) {
          var who = b.customer && b.customer.name ? b.customer.name : (b.customer ? b.customer.phone : '-');
          return '<tr>' +
            '<td>' + fmtDateTime(b.slotStart) + '</td>' +
            '<td>' + esc(who) + '</td>' +
            '<td>' + esc(b.service ? b.service.name : '-') + '</td>' +
            '<td>' + esc(b.status) + '</td>' +
            '<td>' + esc(b.price) + '</td>' +
            '</tr>';
        }).join('');
      }
      $('detailCard').scrollIntoView({ behavior: 'smooth', block: 'start' });
    }).catch(function () {});
  }

  function loadAll() {
    showApp();
    Promise.all([api('/stats'), api('/salons'), api('/growth?days=30')])
      .then(function (out) {
        renderStats(out[0]);
        renderSalons(out[1]);
        renderChart(out[2]);
      })
      .catch(function () {});
  }

  $('loginBtn').addEventListener('click', function () {
    var phone = $('phone').value.trim();
    var password = $('password').value;
    if (!phone || !password) { $('loginErr').textContent = 'Enter phone and password.'; return; }
    $('loginErr').textContent = '';
    $('loginBtn').disabled = true;

    fetch('/api/v2/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ phone: phone, password: password, role: 'SUPER_ADMIN' })
    }).then(function (r) {
      if (!r.ok) throw new Error('Invalid super-admin login.');
      return r.json();
    }).then(function (data) {
      setToken(data.token);
      $('password').value = '';
      loadAll();
    }).catch(function (e) {
      $('loginErr').textContent = e.message || 'Sign in failed.';
    }).finally(function () {
      $('loginBtn').disabled = false;
    });
  });

  $('password').addEventListener('keydown', function (e) {
    if (e.key === 'Enter') $('loginBtn').click();
  });

  $('logoutBtn').addEventListener('click', function () {
    clearToken();
    showLogin('');
  });

  if (token()) loadAll(); else showLogin('');
})();
</script>
</body>
</html>`;
