# Docker-chromium
Thư viện Docker này dùng để chạy Chromium bên trong docker container.

Đọc trong ngôn ngữ khác [Vietnamese | English]
## Tính năng chính
- Chạy chromium trong docker
- Hỗ trợ expose remote debugging

## Cách sử dụng
### Bước 1: Build image
Sử dụng lệnh sau để build Image
```bash
docker build -t chromium .
```
### Bước 2: Sử dụng
Sử dụng lệnh sau để start container
```base
docker compose up --build
```
- Các endpoint:
    - **localhost:8080** : Stream hình ảnh / tương tác với trình duyệt realtime
    - **localhost:\<remote-port\>** : Remote debugging. `remote-port` có thể được đặt bởi ENV `REMOTE-DEBUG_PORT`

## Các package sử dụng
Project sử dụng các package sau:
- **`xvfb`**: Giả lập màn hình ảo
    > Trong Docker không có màn hình vật lý nên phải giả lập để các ứng dụng cần GUI có thể sử dụng
- **`socat`**: Forward địa chỉ 127.0.0.1 (loop back) vào 0.0.0.0 (network interface)
    > Bình thường có thể sử dụng `--remote-debugging-bind=0.0.0.0` nhưng có thể browser không hỗ trợ nên dùng thêm co chắc chắn 
- **`chromium`**: Trình duyệt
- **`x11vnc`**: Cung cấp VNC server, cho phép remote connect tới màn hình ảo tạo bởi `xvfb`.
- **`noVNC`**: chuyển VNC protocol sang WebSocket
    > Bình thường có thể sử dụng VNC client để xem, tuy nhiên chuyển sang Websocket xem luôn trên trình duyệt thì tiện hơn.
- **`supervisord`** Trình quản lý các tiến trình:
    > Do chạy nhiều tiến trình trong một Docker container nên cần phải quản lý chung

Sơ đồ khái quát như sau:
```
Xvfb (:0)  <-- GUI ảo
   │
x11vnc     <-- VNC server trên :0
   │
noVNC      <-- WebSocket server, port 8080, client web connect
   │
Chrome     <-- Browser chạy trên :0, port debug 9223
   │
socat      <-- forward 9224 -> 9223 để host connect
```