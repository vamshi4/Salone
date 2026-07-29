/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  basePath: '/admin',
  // Self-contained server bundle for the production Docker image (see
  // web-superadmin/Dockerfile) — copies only the traced dependencies instead
  // of the whole node_modules tree.
  output: 'standalone',
}

module.exports = nextConfig
