FROM europe-north1-docker.pkg.dev/cgr-nav/pull-through/nav.no/node:24-dev AS builder
WORKDIR /app
COPY package.json pnpm-lock.yaml server.mjs /app/
RUN pnpm install --frozen-lockfile
RUN pnpm exec esbuild server.mjs --bundle --platform=node --outfile=dist/server.js

FROM europe-north1-docker.pkg.dev/cgr-nav/pull-through/nav.no/node:24-slim
WORKDIR /app
COPY --from=builder /app/dist/server.js /app/server.js
COPY --from=builder /app/package.json /app/package.json
COPY --from=builder /app/pnpm-lock.yaml /app/pnpm-lock.yaml
CMD ["server.js"]
