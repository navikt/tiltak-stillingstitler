FROM europe-north1-docker.pkg.dev/cgr-nav/pull-through/nav.no/node:24-dev AS builder
WORKDIR /app
COPY package.json pnpm-lock.yaml server.mjs /app/
RUN pnpm install --frozen-lockfile

FROM europe-north1-docker.pkg.dev/cgr-nav/pull-through/nav.no/node:24-slim
WORKDIR /app
COPY --from=builder /app /app
CMD ["server.mjs"]