FROM cirrusci/flutter:latest-web as builder

USER root

RUN apt-get update && \
    apt-get install -y gpg-agent && \
    rm -rf /var/lib/apt/lists/*

# Install Google Chrome
RUN DEBIAN_FRONTEND=noninteractive \
 && echo 'deb http://dl.google.com/linux/chrome/deb stable main' >> /etc/apt/sources.list.d/google-chrome.list \
 && curl -fL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
 && apt-get update \
 && apt-get install --no-install-recommends -y -q google-chrome-stable \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Build Web Application
FROM builder as webdev

ENV PATH "$PATH:$HOME/.pub-cache/bin"

COPY --chown=cirrus:cirrus ./assets /src/assets
COPY --chown=cirrus:cirrus ./core /src/core
COPY --chown=cirrus:cirrus ./mobile /src/mobile
COPY --chown=cirrus:cirrus ./web /src/web

COPY --chown=cirrus:cirrus ./ci-script.sh /src/
RUN cd /src && ./ci-script.sh

COPY --chown=cirrus:cirrus ./release-all.sh /src/
RUN cd /src && ./release-all.sh

#Deploy SPA
FROM alpine:latest

RUN apk add --no-cache openssh-client tar curl
RUN curl --silent -o - "https://caddyserver.com/api/download?os=linux&arch=amd64" > /usr/bin/caddy
RUN chmod 0755 /usr/bin/caddy

EXPOSE 80 443
WORKDIR /srv
COPY --from=webdev /src/web/build /srv/
COPY Caddyfile /etc/
ENTRYPOINT ["/usr/bin/caddy","run","-config","/etc/Caddyfile"]
