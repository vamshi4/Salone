const createNextIntlPlugin = require('next-intl/plugin');
const withNextIntl = createNextIntlPlugin();

/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  // Self-contained server bundle for the production Docker image (see
  // web-admin/Dockerfile) — copies only the traced dependencies instead of
  // the whole node_modules tree.
  output: 'standalone',
}

module.exports = withNextIntl(nextConfig)
