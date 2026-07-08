// Privacy Policy served at GET /privacy (public). Embedded as a string so it
// ships inside the compiled bundle/Docker image with no static-file copy step.
export const privacyHtml = `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Chairful — Privacy Policy</title>
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
  table { border-collapse:collapse; width:100%; margin:10px 0; font-size:14.5px; }
  th,td { border:1px solid var(--border); padding:8px 10px; text-align:left; vertical-align:top; }
  th { background:#F7F8FA; }
  footer { margin-top:40px; padding-top:16px; border-top:1px solid var(--border); color:var(--muted); font-size:13px; }
</style>
</head>
<body>
<div class="wrap">
  <h1>Privacy Policy — Chairful</h1>
  <p class="meta">Salon management app for salon owners and staff.</p>
  <p class="meta"><strong>Effective date:</strong> 8 July 2026 &nbsp;·&nbsp; <strong>Last updated:</strong> 8 July 2026</p>

  <h2>1. Who we are</h2>
  <p>Chairful (“we”, “us”, the “App”) is a salon management application that helps salon owners and their staff manage appointments, staff, services, and customer relationships. This policy explains what data the App collects, why, and your choices. It applies to the Chairful app published by <strong>vamshi</strong>.</p>

  <h2>2. Information we collect</h2>
  <table>
    <tr><th>Category</th><th>Examples</th><th>Why</th></tr>
    <tr><td>Account information</td><td>Owner name, phone number, email, password (stored only as a salted hash)</td><td>To create and secure your salon account and sign you in</td></tr>
    <tr><td>Salon information</td><td>Salon name, address, and — if you choose “Use my current location” — the salon’s GPS coordinates</td><td>To set up your salon profile and enable location-based features</td></tr>
    <tr><td>Precise location</td><td>Device GPS latitude/longitude, captured <em>only</em> when you tap “Use my current location”</td><td>To fill in and pin your salon’s address accurately. We do <strong>not</strong> track your location in the background.</td></tr>
    <tr><td>Business data you enter</td><td>Your customers’ names and phone numbers, appointments, services, prices, staff details and working hours, notes and tags</td><td>To provide the booking, staff and retention-analytics features you use the App for</td></tr>
    <tr><td>Usage &amp; device data</td><td>App version, basic technical logs</td><td>To keep the App working, secure, and up to date</td></tr>
  </table>

  <h2>3. Customer data you enter (your responsibility)</h2>
  <p>The App lets you store information about <em>your</em> customers (for example, name and phone number). For that data, <strong>you (the salon)</strong> are the data controller and are responsible for having a lawful basis to store it and for informing your customers. We process this data on your behalf solely to provide the App’s features.</p>

  <h2>4. How we use your information</h2>
  <ul>
    <li>Provide, operate, and secure the App and your account.</li>
    <li>Enable bookings, staff management, and retention analytics (e.g. identifying customers who haven’t returned).</li>
    <li>Let you send win-back / reminder messages to your customers via WhatsApp when you choose to.</li>
    <li>Fill in your salon address from your device location when you request it.</li>
    <li>Communicate important service or security updates.</li>
  </ul>
  <p>We do <strong>not</strong> sell your personal data or your customers’ data, and we do not use it for advertising.</p>

  <h2>5. Third-party services</h2>
  <table>
    <tr><th>Service</th><th>What is shared</th><th>Purpose</th></tr>
    <tr><td>OpenStreetMap / Nominatim</td><td>The GPS coordinates you capture (not your identity)</td><td>To convert coordinates into a readable street address</td></tr>
    <tr><td>WhatsApp (Meta)</td><td>Opens WhatsApp with a customer’s number + a message you send; handled by WhatsApp under its own policy</td><td>Only when you tap “Remind”. We don’t send messages automatically or in the background.</td></tr>
    <tr><td>Cloudflare &amp; our hosting</td><td>Standard request/connection data</td><td>To deliver and protect our API securely over HTTPS</td></tr>
  </table>

  <h2>6. How we store and protect data</h2>
  <p>Data is transmitted over encrypted HTTPS and stored on our secured server. Passwords are never stored in plain text — only as a salted scrypt hash. We restrict access to your data to what is needed to operate the service.</p>

  <h2>7. Data retention</h2>
  <p>We keep your account and salon data for as long as your account is active. If you ask us to delete your account, we will delete or anonymize your personal data within a reasonable period, except where we must retain it to comply with law.</p>

  <h2>8. Your rights &amp; choices</h2>
  <ul>
    <li><strong>Location:</strong> optional — the App only reads your location when you tap “Use my current location”, and you can deny or revoke the permission in your device settings at any time.</li>
    <li><strong>Access, correction, deletion:</strong> you can edit your details in the App, and you can request access to or deletion of your account data by contacting us.</li>
  </ul>

  <h2>9. Children</h2>
  <p>Chairful is a business tool intended for salon professionals. It is not directed to children under 13, and we do not knowingly collect their data.</p>

  <h2>10. Changes to this policy</h2>
  <p>We may update this policy from time to time. We will change the “Last updated” date above and, for significant changes, notify you in the App.</p>

  <h2>11. Contact us</h2>
  <p>Questions or requests about this policy or your data: <a href="mailto:vamshikittu114@gmail.com">vamshikittu114@gmail.com</a>.</p>

  <footer>Chairful · This policy covers the Chairful salon management app for Android.</footer>
</div>
</body>
</html>`;
