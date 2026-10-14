# Thư mục lưu trữ ảnh minh chứng (Screenshots)

Bạn hãy chụp và lưu các ảnh màn hình vào thư mục này để chèn vào `README.md` và nộp bài:

1. `01-docker-images.png`:
   - Ảnh chụp cửa sổ PowerShell sau khi chạy lệnh: `docker images`
   - Hiển thị image `campus-hub-backend` và `mysql:8.0`.

2. `02-docker-compose-ps.png`:
   - Ảnh chụp cửa sổ PowerShell sau khi chạy lệnh: `docker compose ps`
   - Hiển thị cả 2 container `campus-hub-backend` và `campus-hub-mysql` đang ở trạng thái `running` (Up) và MySQL `(healthy)`.

3. `03-actuator-health.png`:
   - Ảnh chụp trình duyệt truy cập `http://localhost:8080/actuator/health` hoặc kết quả lệnh PowerShell `curl.exe http://localhost:8080/actuator/health`.
   - Kết quả trả về JSON có `"status":"UP"`.
