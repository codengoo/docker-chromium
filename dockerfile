FROM debian:bookworm

ARG S6_OVERLAY_VERSION=v3.2.1.0
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBUG_PORT=9223
ENV CHROME_FLAGS=""

# Cập nhật và cài đặt gói cần thiết
RUN apt-get update && apt-get install -y \
    wget gnupg2 ca-certificates \
    xvfb x11vnc socat  \
    novnc websockify \
    && rm -rf /var/lib/apt/lists/*

# Cài đặt s6-overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz

# Cài nodejs 
RUN apt-get update && apt-get install -y curl \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root

# Copy file config
COPY services/ /etc/services.d/
RUN chmod -R +x /etc/services.d/ \
    && apt-get update && apt-get install -y dos2unix \
    && find /etc/services.d/ -type f -name 'run' -exec dos2unix {} \;
COPY package.json ./

# Cài đặt chromium với Playwright
RUN npm install
RUN ./node_modules/playwright-core/cli.js install --with-deps chromium

# Expose cổng cho noVNC và remote debugging
EXPOSE 8080
EXPOSE ${DEBUG_PORT}:${DEBUG_PORT}

ENTRYPOINT ["/init"]