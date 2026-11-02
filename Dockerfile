FROM node:22-slim AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN npm install -g pnpm@10.15.1

FROM base AS build
WORKDIR /app
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml* ./
ENV NODE_ENV=development
RUN pnpm install --frozen-lockfile
COPY . .
RUN pnpm install --prod --frozen-lockfile

FROM base AS runner
WORKDIR /app
ENV NODE_ENV=production

RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates \
 && curl -L "https://github.com/caddyserver/caddy/releases/download/v2.11.7/caddy_2.11.7_linux_amd64.tar.gz" | tar -xz -C /usr/bin caddy \
 && chmod +x /usr/bin/caddy \
 && rm -rf /var/lib/apt/lists/*

COPY --from=build /app .
COPY Caddyfile .

EXPOSE 8080

CMD ["sh", "-c", "pnpm run start & caddy run --config Caddyfile --adapter caddyfile"]