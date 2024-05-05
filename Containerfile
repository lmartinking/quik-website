FROM caddy:2.7-alpine

COPY Caddyfile /etc/caddy/Caddyfile
COPY content /srv

LABEL org.opencontainers.image.source=https://github.com/lmartinking/quik-website
LABEL org.opencontainers.image.authors="Lucas Martin-King"
