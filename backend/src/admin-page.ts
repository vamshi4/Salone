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
  :root { --ink:#0F172A; --muted:#5B6B66; --accent:#0E7C6B; --border:#ECEEF1; --bg:#F7F8FA; --danger:#B4232B; }
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
  button.danger { background:var(--danger); border-color:var(--danger); color:#fff; }
  button.small { padding:5px 10px; font-size:13px; }
  button:disabled { opacity:.5; cursor:not-allowed; }
  input, select { font:inherit; padding:10px 12px; border:1px solid var(--border);
    border-radius:8px; width:100%; background:#fff; color:var(--ink); }
  .login { max-width:360px; margin:70px auto; background:#fff; padding:26px;
    border:1px solid var(--border); border-radius:14px; }
  .login h2 { margin:0 0 4px; font-size:22px; }
  .login p { color:var(--muted); margin:0 0 18px; font-size:14px; }
  .login label { display:block; font-size:13px; color:var(--muted); margin:12px 0 5px; }
  .err { color:var(--danger); font-size:13.5px; margin-top:12px; min-height:18px; }
  .kpis { display:grid; grid-template-columns:repeat(auto-fit,minmax(160px,1fr)); gap:12px; }
  .kpi { background:#fff; border:1px solid var(--border); border-radius:12px; padding:15px 16px; }
  .kpi .n { font-size:26px; font-weight:600; letter-spacing:-.02em; }
  .kpi .l { font-size:12.5px; color:var(--muted); margin-top:3px; }
  .kpi.warn .n { color:var(--danger); }
  .card { background:#fff; border:1px solid var(--border); border-radius:12px;
    padding:18px; margin-top:20px; }
  .card h3 { margin:0 0 14px; font-size:15px; }
  .scroll { overflow-x:auto; }
  table { border-collapse:collapse; width:100%; font-size:14px; }
  th,td { border-bottom:1px solid var(--border); padding:9px 10px; text-align:left; white-space:nowrap; }
  th { color:var(--muted); font-weight:500; font-size:12.5px; }
  tbody tr.rowlink:hover { background:#F7FBFA; cursor:pointer; }
  .pill { display:inline-block; padding:2px 8px; border-radius:20px; font-size:12px;
    background:#EEF5F3; color:var(--accent); }
  .pill.dim { background:#F1F2F4; color:var(--muted); }
  .hidden { display:none; }
  .legend { font-size:12.5px; color:var(--muted); margin-top:8px; }
  .sw { display:inline-block; width:9px; height:9px; border-radius:2px; margin-right:5px; }
  .muted { color:var(--muted); }
  .tabs { display:flex; gap:8px; margin-bottom:4px; }
  .tab { background:#fff; color:var(--muted); border:1px solid var(--border); }
  .tab.active { background:var(--accent); color:#fff; border-color:var(--accent); }
  .subcard { border:1px solid var(--border); border-radius:10px; padding:14px; margin-top:14px; }
  .subcard h4 { margin:0 0 12px; font-size:13.5px; }
  .formgrid { display:grid; grid-template-columns:repeat(auto-fit,minmax(180px,1fr)); gap:12px; align-items:end; }
  .formgrid label { font-size:12.5px; color:var(--muted); display:block; margin-bottom:5px; }
  .actions-row { margin-top:12px; display:flex; gap:8px; flex-wrap:wrap; align-items:center; }
  .badge { font-size:11.5px; color:var(--muted); }
  .overlay { position:fixed; inset:0; background:rgba(15,23,42,.45); display:flex;
    align-items:center; justify-content:center; z-index:50; padding:16px; }
  .modal { background:#fff; border-radius:14px; padding:22px; max-width:420px; width:100%; }
  .modal h3 { margin:0 0 8px; font-size:17px; }
  .modal p { color:var(--muted); font-size:14px; margin:0 0 14px; line-height:1.45; }
  .modal .actions { display:flex; gap:10px; justify-content:flex-end; margin-top:16px; }
  .toast { position:fixed; left:50%; bottom:28px; transform:translateX(-50%); background:var(--ink);
    color:#fff; padding:11px 18px; border-radius:10px; font-size:14px; opacity:0;
    transition:opacity .2s; z-index:60; pointer-events:none; max-width:90%; }
  .toast.show { opacity:1; }
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
    <div class="tabs">
      <button class="tab active" id="tabDash">Dashboard</button>
      <button class="tab" id="tabDeleted">Deleted</button>
      <button class="tab" id="tabAudit">Audit</button>
    </div>

    <div id="dashView">
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

        <div class="subcard">
          <h4>Salon details</h4>
          <div class="formgrid">
            <div><label>Name</label><input id="sName"></div>
            <div><label>Address</label><input id="sAddress"></div>
            <div><label>Plan</label><select id="sPlan"></select></div>
            <div><label>Commission %</label><input id="sCommission" type="number" min="0" max="100"></div>
          </div>
          <div class="actions-row">
            <button id="sSave">Save changes</button>
            <button class="danger" id="sDelete">Delete salon</button>
          </div>
        </div>

        <div class="subcard" id="ownerBox"></div>

        <div class="subcard">
          <h4>Recent bookings</h4>
          <div class="scroll">
            <table>
              <thead><tr><th>When</th><th>Customer</th><th>Service</th><th>Status</th><th>Price</th><th></th></tr></thead>
              <tbody id="detailRows"></tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

    <div id="deletedView" class="hidden">
      <div class="card">
        <h3>Deleted salons</h3>
        <div class="scroll">
          <table>
            <thead><tr><th>Salon</th><th>Owner</th><th>Plan</th><th>Deleted</th><th></th></tr></thead>
            <tbody id="delSalonRows"></tbody>
          </table>
        </div>
      </div>
      <div class="card">
        <h3>Deleted users</h3>
        <div class="scroll">
          <table>
            <thead><tr><th>Name</th><th>Phone</th><th>Email</th><th>Role</th><th>Deleted</th><th></th></tr></thead>
            <tbody id="delUserRows"></tbody>
          </table>
        </div>
      </div>
    </div>

    <div id="auditView" class="hidden">
      <div class="card">
        <h3>Recent admin actions</h3>
        <div class="scroll">
          <table>
            <thead><tr><th>When</th><th>Action</th><th>Target</th><th>Target ID</th><th>Actor</th></tr></thead>
            <tbody id="auditRows"></tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>

<div id="toast" class="toast"></div>

<script>
(function () {
  var TOKEN_KEY = 'chairful_admin_token';
  var ID_KEY = 'chairful_admin_id';
  var $ = function (id) { return document.getElementById(id); };

  var PLANS = ['FREE', 'PREMIUM'];
  var ROLES = ['CUSTOMER', 'STYLIST', 'SALON_OWNER', 'SUPER_ADMIN'];
  var STATUSES = ['PENDING', 'PENDING_RESCHEDULE', 'CONFIRMED', 'COMPLETED', 'CANCELLED', 'NO_SHOW'];

  var adminId = localStorage.getItem(ID_KEY) || '';
  var currentSalon = null;
  var currentOwner = null;

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
  function clearToken() { localStorage.removeItem(TOKEN_KEY); localStorage.removeItem(ID_KEY); }

  var toastTimer;
  function toast(msg) {
    var t = $('toast');
    t.textContent = msg;
    t.classList.add('show');
    clearTimeout(toastTimer);
    toastTimer = setTimeout(function () { t.classList.remove('show'); }, 2600);
  }
  function fail(e) { if (e && e.message && e.message !== 'unauthorized') toast(e.message); }

  function showLogin(message) {
    $('appView').classList.add('hidden');
    $('loginView').classList.remove('hidden');
    $('loginErr').textContent = message || '';
  }
  function showApp() {
    $('loginView').classList.add('hidden');
    $('appView').classList.remove('hidden');
  }

  // Generalized API caller: api(path) for GET, api(path, 'PATCH', body) for writes.
  // Surfaces the server's { error } message so it can land in a toast.
  function api(path, method, body) {
    var opts = { method: method || 'GET', headers: { Authorization: 'Bearer ' + token() } };
    if (body !== undefined) {
      opts.headers['Content-Type'] = 'application/json';
      opts.body = JSON.stringify(body);
    }
    return fetch('/api/v2/admin' + path, opts).then(function (r) {
      if (r.status === 401 || r.status === 403) {
        clearToken();
        showLogin('Session expired. Please sign in again.');
        throw new Error('unauthorized');
      }
      return r.json().catch(function () { return {}; }).then(function (data) {
        if (!r.ok) throw new Error(data && data.error ? data.error : ('Request failed (' + r.status + ')'));
        return data;
      });
    });
  }

  // GitHub-style typed confirmation. Resolves true only if the user types the
  // exact match string (salon name / owner phone) before clicking confirm.
  function typedConfirm(opts) {
    return new Promise(function (resolve) {
      var ov = document.createElement('div');
      ov.className = 'overlay';
      ov.innerHTML =
        '<div class="modal">' +
          '<h3>' + esc(opts.title) + '</h3>' +
          '<p>' + opts.message + '</p>' +
          '<input id="cfInput" autocomplete="off" placeholder="' + esc(opts.match) + '">' +
          '<div class="actions">' +
            '<button class="ghost" id="cfCancel">Cancel</button>' +
            '<button class="danger" id="cfOk" disabled>' + esc(opts.confirmLabel || 'Delete') + '</button>' +
          '</div>' +
        '</div>';
      document.body.appendChild(ov);
      var input = ov.querySelector('#cfInput');
      var ok = ov.querySelector('#cfOk');
      function close(result) { document.body.removeChild(ov); resolve(result); }
      input.addEventListener('input', function () { ok.disabled = input.value.trim() !== opts.match; });
      ov.querySelector('#cfCancel').addEventListener('click', function () { close(false); });
      ok.addEventListener('click', function () { if (input.value.trim() === opts.match) close(true); });
      ov.addEventListener('click', function (e) { if (e.target === ov) close(false); });
      input.focus();
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
      return '<tr class="rowlink" data-id="' + esc(r.id) + '">' +
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

  function renderSalonEdit(salon) {
    currentSalon = { id: salon.id, name: salon.name };
    var plans = PLANS.slice();
    if (salon.saasPlan && plans.indexOf(salon.saasPlan) < 0) plans.unshift(salon.saasPlan);
    $('sPlan').innerHTML = plans.map(function (p) {
      return '<option value="' + esc(p) + '"' + (p === salon.saasPlan ? ' selected' : '') + '>' + esc(p) + '</option>';
    }).join('');
    $('sName').value = salon.name || '';
    $('sAddress').value = salon.address || '';
    $('sCommission').value = salon.commissionRate;
  }

  function renderOwner(o) {
    currentOwner = o;
    var isSelf = o.id === adminId;
    var roleOpts = ROLES.map(function (r) {
      return '<option value="' + r + '"' + (r === o.role ? ' selected' : '') + '>' + r + '</option>';
    }).join('');
    $('ownerBox').innerHTML =
      '<h4>Owner</h4>' +
      '<div class="formgrid">' +
        '<div><label>Name</label><input id="oName"></div>' +
        '<div><label>Phone</label><input id="oPhone"></div>' +
        '<div><label>Email</label><input id="oEmail" type="email"></div>' +
      '</div>' +
      '<div class="actions-row">' +
        '<button id="oSave">Save owner</button>' +
        '<button class="ghost" id="oResetPw">Reset password</button>' +
        (isSelf ? '' :
          '<select id="oRole" style="width:auto">' + roleOpts + '</select>' +
          '<button class="ghost small" id="oRoleApply">Change role</button>' +
          '<button class="danger" id="oDelete">Delete owner</button>') +
      '</div>' +
      (isSelf ? '<p class="badge" style="margin-top:8px">This is your own account — role change and delete are disabled.</p>' : '');

    $('oName').value = o.name || '';
    $('oPhone').value = o.phone || '';
    $('oEmail').value = o.email || '';

    $('oSave').onclick = function () {
      api('/users/' + encodeURIComponent(o.id), 'PATCH', {
        name: $('oName').value.trim(),
        phone: $('oPhone').value.trim(),
        email: $('oEmail').value.trim()
      }).then(function () { toast('Owner updated'); refreshDashboard(); reloadDetail(currentSalon.id); }).catch(fail);
    };

    $('oResetPw').onclick = function () {
      var pw = window.prompt('New password for ' + (o.name || o.phone) + ' (min 12 characters):');
      if (pw === null) return;
      if (pw.length < 12) { toast('Password must be at least 12 characters'); return; }
      api('/users/' + encodeURIComponent(o.id) + '/reset-password', 'POST', { password: pw })
        .then(function () { toast('Password reset'); }).catch(fail);
    };

    if (!isSelf) {
      $('oRoleApply').onclick = function () {
        api('/users/' + encodeURIComponent(o.id) + '/role', 'PATCH', { role: $('oRole').value })
          .then(function () { toast('Role changed'); refreshDashboard(); reloadDetail(currentSalon.id); }).catch(fail);
      };
      $('oDelete').onclick = function () {
        typedConfirm({
          title: 'Delete owner',
          message: 'This soft-deletes <b>' + esc(o.name || o.phone) + '</b> and blocks their login. Type the owner phone <b>' + esc(o.phone) + '</b> to confirm.',
          match: o.phone,
          confirmLabel: 'Delete owner'
        }).then(function (ok) {
          if (!ok) return;
          api('/users/' + encodeURIComponent(o.id), 'DELETE')
            .then(function () { toast('Owner deleted'); refreshDashboard(); reloadDetail(currentSalon.id); }).catch(fail);
        });
      };
    }
  }

  function renderDetailBookings(bookings) {
    if (!bookings.length) {
      $('detailRows').innerHTML = '<tr><td colspan="6" class="muted">No bookings yet.</td></tr>';
      return;
    }
    $('detailRows').innerHTML = bookings.map(function (b) {
      var who = b.customer && b.customer.name ? b.customer.name : (b.customer ? b.customer.phone : '-');
      var sel = '<select class="bk-status" data-id="' + esc(b.id) + '">' +
        STATUSES.map(function (s) { return '<option' + (s === b.status ? ' selected' : '') + '>' + s + '</option>'; }).join('') +
        '</select>';
      return '<tr>' +
        '<td>' + fmtDateTime(b.slotStart) + '</td>' +
        '<td>' + esc(who) + '</td>' +
        '<td>' + esc(b.service ? b.service.name : '-') + '</td>' +
        '<td>' + sel + '</td>' +
        '<td>' + esc(b.price) + '</td>' +
        '<td><button class="danger small bk-del" data-id="' + esc(b.id) + '">Delete</button></td>' +
        '</tr>';
    }).join('');

    Array.prototype.forEach.call($('detailRows').querySelectorAll('.bk-status'), function (sel) {
      sel.addEventListener('change', function () {
        api('/bookings/' + encodeURIComponent(sel.getAttribute('data-id')), 'PATCH', { status: sel.value })
          .then(function () { toast('Booking status updated'); }).catch(fail);
      });
    });
    Array.prototype.forEach.call($('detailRows').querySelectorAll('.bk-del'), function (btn) {
      btn.addEventListener('click', function () {
        if (!window.confirm('Delete this booking permanently? This cannot be undone.')) return;
        api('/bookings/' + encodeURIComponent(btn.getAttribute('data-id')), 'DELETE')
          .then(function () { toast('Booking deleted'); refreshDashboard(); reloadDetail(currentSalon.id); }).catch(fail);
      });
    });
  }

  function loadDetail(id) {
    api('/salons/' + encodeURIComponent(id)).then(function (data) {
      $('detailCard').classList.remove('hidden');
      $('detailTitle').textContent = data.salon.name;
      renderSalonEdit(data.salon);
      renderOwner(data.salon.owner);
      renderDetailBookings(data.bookings);
      $('detailCard').scrollIntoView({ behavior: 'smooth', block: 'start' });
    }).catch(fail);
  }

  function reloadDetail(id) {
    if (id) loadDetail(id);
  }

  $('sSave').addEventListener('click', function () {
    if (!currentSalon) return;
    var commission = Number($('sCommission').value);
    api('/salons/' + encodeURIComponent(currentSalon.id), 'PATCH', {
      name: $('sName').value.trim(),
      address: $('sAddress').value.trim(),
      saasPlan: $('sPlan').value,
      commissionRate: commission
    }).then(function () { toast('Salon updated'); refreshDashboard(); reloadDetail(currentSalon.id); }).catch(fail);
  });

  $('sDelete').addEventListener('click', function () {
    if (!currentSalon) return;
    typedConfirm({
      title: 'Delete salon',
      message: 'This soft-deletes <b>' + esc(currentSalon.name) + '</b> and hides it from the apps. Type the salon name to confirm.',
      match: currentSalon.name,
      confirmLabel: 'Delete salon'
    }).then(function (ok) {
      if (!ok) return;
      api('/salons/' + encodeURIComponent(currentSalon.id), 'DELETE').then(function () {
        toast('Salon deleted');
        $('detailCard').classList.add('hidden');
        currentSalon = null;
        refreshDashboard();
      }).catch(fail);
    });
  });

  function renderDeleted(data) {
    if (!data.salons.length) {
      $('delSalonRows').innerHTML = '<tr><td colspan="5" class="muted">No deleted salons.</td></tr>';
    } else {
      $('delSalonRows').innerHTML = data.salons.map(function (s) {
        return '<tr>' +
          '<td>' + esc(s.name) + '</td>' +
          '<td>' + esc(s.owner ? (s.owner.name || s.owner.phone) : '-') + '</td>' +
          '<td>' + planPill(s.saasPlan) + '</td>' +
          '<td>' + fmtDateTime(s.deletedAt) + '</td>' +
          '<td><button class="ghost small" data-restore-salon="' + esc(s.id) + '">Restore</button></td>' +
          '</tr>';
      }).join('');
    }
    if (!data.users.length) {
      $('delUserRows').innerHTML = '<tr><td colspan="6" class="muted">No deleted users.</td></tr>';
    } else {
      $('delUserRows').innerHTML = data.users.map(function (u) {
        return '<tr>' +
          '<td>' + esc(u.name || '-') + '</td>' +
          '<td>' + esc(u.phone) + '</td>' +
          '<td>' + esc(u.email || '-') + '</td>' +
          '<td>' + esc(u.role) + '</td>' +
          '<td>' + fmtDateTime(u.deletedAt) + '</td>' +
          '<td><button class="ghost small" data-restore-user="' + esc(u.id) + '">Restore</button></td>' +
          '</tr>';
      }).join('');
    }

    Array.prototype.forEach.call(document.querySelectorAll('[data-restore-salon]'), function (btn) {
      btn.addEventListener('click', function () {
        api('/salons/' + encodeURIComponent(btn.getAttribute('data-restore-salon')) + '/restore', 'POST')
          .then(function () { toast('Salon restored'); loadDeleted(); refreshDashboard(); }).catch(fail);
      });
    });
    Array.prototype.forEach.call(document.querySelectorAll('[data-restore-user]'), function (btn) {
      btn.addEventListener('click', function () {
        api('/users/' + encodeURIComponent(btn.getAttribute('data-restore-user')) + '/restore', 'POST')
          .then(function () { toast('User restored'); loadDeleted(); refreshDashboard(); }).catch(fail);
      });
    });
  }

  function loadDeleted() {
    api('/deleted').then(renderDeleted).catch(fail);
  }

  function renderAudit(rows) {
    if (!rows.length) {
      $('auditRows').innerHTML = '<tr><td colspan="5" class="muted">No admin actions yet.</td></tr>';
      return;
    }
    $('auditRows').innerHTML = rows.map(function (a) {
      return '<tr>' +
        '<td>' + fmtDateTime(a.createdAt) + '</td>' +
        '<td>' + esc(a.action) + '</td>' +
        '<td>' + esc(a.targetType) + '</td>' +
        '<td>' + esc(a.targetId) + '</td>' +
        '<td>' + esc(a.actorId) + '</td>' +
        '</tr>';
    }).join('');
  }

  function loadAudit() {
    api('/audit?limit=100').then(renderAudit).catch(fail);
  }

  function switchTab(name) {
    $('tabDash').classList.toggle('active', name === 'dash');
    $('tabDeleted').classList.toggle('active', name === 'deleted');
    $('tabAudit').classList.toggle('active', name === 'audit');
    $('dashView').classList.toggle('hidden', name !== 'dash');
    $('deletedView').classList.toggle('hidden', name !== 'deleted');
    $('auditView').classList.toggle('hidden', name !== 'audit');
    if (name === 'deleted') loadDeleted();
    if (name === 'audit') loadAudit();
  }

  $('tabDash').addEventListener('click', function () { switchTab('dash'); });
  $('tabDeleted').addEventListener('click', function () { switchTab('deleted'); });
  $('tabAudit').addEventListener('click', function () { switchTab('audit'); });

  function refreshDashboard() {
    return Promise.all([api('/stats'), api('/salons'), api('/growth?days=30')])
      .then(function (out) {
        renderStats(out[0]);
        renderSalons(out[1]);
        renderChart(out[2]);
      })
      .catch(fail);
  }

  function loadAll() {
    showApp();
    switchTab('dash');
    refreshDashboard();
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
      if (data.user && data.user.id) {
        adminId = data.user.id;
        localStorage.setItem(ID_KEY, adminId);
      }
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
    adminId = '';
    showLogin('');
  });

  if (token()) loadAll(); else showLogin('');
})();
</script>
</body>
</html>`;
