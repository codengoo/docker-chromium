FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Cài đặt gói cần thiết
RUN apt-get update && apt-get install -y \
    wget gnupg2 ca-certificates \
    xvfb x11vnc \
    novnc websockify \
    supervisor \
    chromium \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root

# Thêm script chạy chrome
COPY start-chrome.sh /usr/local/bin/start-chrome.sh
RUN chmod +x /usr/local/bin/start-chrome.sh

# Copy file supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8080

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
