FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# NEXT_PUBLIC_* vars are inlined into the client bundle at build time, not
# read from the container's runtime environment — must be passed as build
# args (see .github/workflows/superadmin-image.yml).
ARG NEXT_PUBLIC_API_URL
ENV NEXT_PUBLIC_API_URL=$NEXT_PUBLIC_API_URL

RUN npm run build

FROM node:20-alpine
WORKDIR /app
ENV NODE_ENV=production
# `output: 'standalone'` (next.config.js) traces only the deps this app
# actually uses instead of copying the whole node_modules tree.
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public
EXPOSE 3000
CMD ["node", "server.js"]
