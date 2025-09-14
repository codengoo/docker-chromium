FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Cập nhật và cài đặt gói cần thiết
RUN apt-get update && apt-get install -y \
    wget gnupg2 ca-certificates \
    xvfb x11vnc socat  \
    novnc websockify \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y curl \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root

# Copy file supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY package.json ./

# Cài đặt nodejs
RUN npm install
RUN ./node_modules/playwright-core/cli.js install --with-deps chromium

# Expose cổng cho noVNC và remote debugging
EXPOSE 8080
EXPOSE 9223
EXPOSE 9224

CMD ["/usr/bin/supervisord", "-n"]
