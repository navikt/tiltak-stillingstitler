FROM europe-north1-docker.pkg.dev/cgr-nav/pull-through/nav.no/node:24-dev AS builder
WORKDIR /app
COPY package.json pnpm-lock.yaml server.mjs /app/
RUN pnpm install --frozen-lockfile
RUN pnpm esbuild server.mjs --bundle --platform=node --outfile=dist/server.js

FROM europe-north1-docker.pkg.dev/cgr-nav/pull-through/nav.no/node:24-slim AS dev
WORKDIR /app
ENV PAM_URL=https://pam-ontologi.intern.dev.nav.no
COPY --from=builder /app/dist/server.js /app/server.js
CMD ["server.js"]

FROM europe-north1-docker.pkg.dev/cgr-nav/pull-through/nav.no/node:24-slim AS prod
WORKDIR /app
COPY --from=builder /app/dist/server.js /app/server.js
COPY --from=builder /app/package.json /app/package.json
COPY --from=builder /app/pnpm-lock.yaml /app/pnpm-lock.yaml
CMD ["server.js"]
