// Account deletion instructions served at GET /delete-account (public).
// Required by Google Play Data safety: a dedicated page that shows how users
// request account deletion and what data is removed vs. retained.
export const deleteAccountHtml = `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Chairful — Delete your account</title>
<style>
  :root { --ink:#0F172A; --muted:#5B6B66; --accent:#0E7C6B; --border:#ECEEF1; }
  * { box-sizing:border-box; }
  body { margin:0; background:#fff; color:var(--ink);
    font-family:system-ui,-apple-system,"Segoe UI",Roboto,sans-serif; line-height:1.6; }
  .wrap { max-width:760px; margin:0 auto; padding:40px 22px 80px; }
  h1 { font-size:30px; letter-spacing:-.02em; margin:0 0 4px; }
  h2 { font-size:19px; margin:34px 0 8px; }
  .meta { color:var(--muted); font-size:14px; margin-bottom:8px; }
  p, li { font-size:15.5px; }
  a { color:var(--accent); }
  ol li { margin:6px 0; }
  table { border-collapse:collapse; width:100%; margin:10px 0; font-size:14.5px; }
  th,td { border:1px solid var(--border); padding:8px 10px; text-align:left; vertical-align:top; }
  th { background:#F7F8FA; }
  .step { background:#F7FBFA; border:1px solid #D9EDE9; border-radius:10px; padding:14px 16px; margin:12px 0; }
  footer { margin-top:40px; padding-top:16px; border-top:1px solid var(--border); color:var(--muted); font-size:13px; }
</style>
</head>
<body>
<div class="wrap">
  <h1>Delete your Chairful account</h1>
  <p class="meta">This page explains how to request deletion of your <strong>Chairful</strong> account and the data associated with it. Chairful is published by <strong>vamshi</strong>.</p>

  <h2>How to request account deletion</h2>
  <div class="step">
    <ol>
      <li>Send an email to <a href="mailto:vamshikittu114@gmail.com?subject=Delete%20my%20Chairful%20account">vamshikittu114@gmail.com</a> from any address, with the subject <strong>"Delete my Chairful account"</strong>.</li>
      <li>Include the <strong>phone number</strong> you use to sign in to Chairful, and your <strong>salon name</strong>, so we can locate your account.</li>
      <li>We verify the request is coming from the account owner, then delete the account.</li>
    </ol>
  </div>
  <p>We action deletion requests within <strong>30 days</strong> of verifying them.</p>

  <h2>What data is deleted</h2>
  <p>When your account is deleted, we permanently remove:</p>
  <table>
    <tr><th>Data</th><th>Status</th></tr>
    <tr><td>Your owner profile (name, phone number, email, password hash)</td><td>Deleted</td></tr>
    <tr><td>Your salon details (name, address, GPS location if you set it)</td><td>Deleted</td></tr>
    <tr><td>Your staff, services and working hours</td><td>Deleted</td></tr>
    <tr><td>Your customer records (names, phone numbers, notes, tags)</td><td>Deleted</td></tr>
    <tr><td>Your bookings and appointment history</td><td>Deleted</td></tr>
  </table>

  <h2>What data may be kept</h2>
  <p>We may retain a limited set of records only where the law requires it (for example, basic transaction or tax records), and any anonymized/aggregated data that no longer identifies you or your customers. Anything retained for legal reasons is deleted once the required retention period ends.</p>

  <h2>Questions</h2>
  <p>For any question about deleting your account or data, contact <a href="mailto:vamshikittu114@gmail.com">vamshikittu114@gmail.com</a>. See also our <a href="/privacy">Privacy Policy</a>.</p>

  <footer>Chairful · Account &amp; data deletion for the Chairful salon management app for Android.</footer>
</div>
</body>
</html>`;
