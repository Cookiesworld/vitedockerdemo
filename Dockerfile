FROM node:20.11.1-alpine3.19 AS builder

WORKDIR /build

COPY ./package.json ./
COPY ./package-lock.json ./

RUN npm install

COPY public ./public
COPY src ./src
COPY index.html ./
COPY tsconfig.json ./
COPY tsconfig.app.json ./
COPY tsconfig.node.json ./
COPY vite.config.ts ./

RUN npm run build

FROM nginxinc/nginx-unprivileged:1.27.0 AS final
WORKDIR /app
COPY --from=builder /build/dist/ /app/
COPY nginx.conf /etc/nginx/conf.d/default.conf

