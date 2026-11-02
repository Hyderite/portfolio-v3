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
RUN pnpm install --workspace-root --prod --frozen-lockfile

FROM base AS runner
WORKDIR /app
ENV NODE_ENV=production

COPY --from=build /app .

EXPOSE 8080

CMD ["pnpm", "run", "start"]