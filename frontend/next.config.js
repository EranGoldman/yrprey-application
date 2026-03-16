/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  output: "standalone",
  experimental: {
    outputStandalone: true,
  },
  images: {
    domains: ["*"],
  },
};

module.exports = nextConfig;
