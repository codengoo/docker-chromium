FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Cài đặt các gói cần thiết
RUN apt-get update && apt-get install -y \
    wget gnupg2 ca-certificates \
    xvfb x11vnc fluxbox \
    novnc websockify \
    supervisor \
    chromium \
    && rm -rf /var/lib/apt/lists/*

# Tạo thư mục làm việc
WORKDIR /root

# Copy config cho supervisor để quản lý các service
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Mở port cho noVNC
EXPOSE 8080

CMD ["/usr/bin/supervisord"]
