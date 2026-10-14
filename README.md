# Campus Hub Base

Campus Hub là dự án nền cho Mini Project Session 13. Ứng dụng cung cấp một không gian chung để sinh viên đăng sự kiện, tìm đồ thất lạc, hỏi đáp, trao đổi đồ dùng và tìm nhóm.

Dự án được giữ ở mức nhỏ để dễ đọc và sửa đổi, nhưng đã có đủ luồng giao diện, API, xác thực, migration và kiểm thử.

## Chức năng có sẵn

- Xem, tìm kiếm và lọc bài đăng.
- Đăng ký, đăng nhập bằng HTTP Basic.
- Tạo bài đăng theo chuyên mục.
- Bình luận và bày tỏ quan tâm.
- Chủ bài đăng có thể đánh dấu bài đã hoàn tất.
- Quản trị viên có quyền quản lý trạng thái bài đăng qua API.
- Health check tại `/actuator/health`.

Tài khoản mẫu được tạo khi ứng dụng khởi động lần đầu:

| Vai trò | Tên đăng nhập | Mật khẩu |
|---|---|---|
| Sinh viên | `student` | `student123` |
| Quản trị viên | `admin` | `admin123` |

Các tài khoản này chỉ dùng để trình diễn. Nhóm cần thay đổi hoặc loại bỏ trước khi sử dụng trong bối cảnh thực tế.

## Kiến trúc

```text
React frontend
    │ /api
    ▼
Spring Boot monolith
    │ JDBC
    ▼
MySQL
```

Backend gồm năm bảng chính: `users`, `categories`, `posts`, `comments` và `reactions`. Frontend không sử dụng thư viện giao diện hay thư viện quản lý trạng thái để sinh viên dễ đọc mã nguồn.

## Chạy khi phát triển

Tạo database MySQL tên `campus_hub`, sau đó đặt các biến môi trường nếu thông tin kết nối khác giá trị mặc định:

```powershell
$env:DB_URL = "jdbc:mysql://localhost:3306/campus_hub"
$env:DB_USERNAME = "root"
$env:DB_PASSWORD = "12345678"
```

Chạy backend:

```powershell
cd backend
./gradlew.bat bootRun
```

Mở terminal khác để chạy frontend:

```powershell
cd frontend
npm install
npm run dev
```

Frontend phát triển chạy tại `http://localhost:5173` và chuyển tiếp `/api` tới backend tại cổng `8080`.

## API chính

| Phương thức | Đường dẫn | Mục đích | Xác thực |
|---|---|---|---|
| `POST` | `/api/auth/register` | Tạo tài khoản | Không |
| `GET` | `/api/auth/me` | Lấy người dùng hiện tại | Có |
| `GET` | `/api/categories` | Danh sách chuyên mục | Không |
| `GET` | `/api/posts` | Tìm và lọc bài đăng | Không |
| `GET` | `/api/posts/{id}` | Chi tiết bài đăng | Không |
| `POST` | `/api/posts` | Tạo bài đăng | Có |
| `PUT` | `/api/posts/{id}` | Sửa bài của mình | Có |
| `PATCH` | `/api/posts/{id}/status` | Đổi trạng thái | Có |
| `DELETE` | `/api/posts/{id}` | Xóa bài của mình | Có |
| `POST` | `/api/posts/{id}/comments` | Thêm bình luận | Có |
| `POST` | `/api/posts/{id}/reaction` | Bật hoặc tắt quan tâm | Có |

Các API cần xác thực sử dụng header HTTP Basic. Trong môi trường công khai, hệ thống phải được đặt sau HTTPS.

## Kiểm tra trước khi bàn giao

```powershell
cd backend
./gradlew.bat test

cd ../frontend
npm ci
npm run lint
npm run build
```

## Phạm vi cố ý để mở

Dự án nền chưa có tải tệp, thông báo thời gian thực, email, phân trang trên giao diện, lịch sử thay đổi, dashboard và quy trình kiểm duyệt hoàn chỉnh. Nhóm có thể phát triển các hướng này, sửa sâu dự án nền hoặc thay thế toàn bộ công nghệ nếu phù hợp với ý tưởng của mình.

Dự án không cung cấp sẵn Dockerfile, Docker Compose, cấu hình web server hoặc quy trình CI/CD. Phân tích hệ thống và lựa chọn toàn bộ phương án xây dựng, đóng gói, triển khai là công việc của từng nhóm trong Mini Project.

---

## Hướng dẫn Triển khai và Kiểm tra bằng Docker

### Thông tin sinh viên thực hiện
- **Họ và tên**: Đỗ Đức Mạnh
- **Mã sinh viên (MSSV)**: HN-PTIT-214
- **Lớp**: HN_KS24_CNTT2

### 1. Yêu cầu môi trường
- Hệ điều hành: Windows 10/11 64-bit.
- Đã cài đặt và khởi chạy **Docker Desktop** (bật WSL 2 backend).
- Đã cài đặt **Git**.
- *(Tùy chọn khi chạy test cục bộ)*: JDK 21 trở lên để chạy Gradle Wrapper (`.\gradlew.bat test`).

### 2. Chuẩn bị file cấu hình môi trường (.env)
Dự án đã có file mẫu [.env.example](file:///d:/campus-hub-base-main/.env.example). Tạo file `.env` tại thư mục gốc:

```powershell
# Sao chép từ file mẫu .env.example
Copy-Item .env.example .env
```

Nội dung `.env` mẫu:
```env
MYSQL_DATABASE=campus_hub
MYSQL_USER=campus_user
MYSQL_PASSWORD=campus_secret
MYSQL_ROOT_PASSWORD=root_secret
MYSQL_PORT=3306

SERVER_PORT=8080
DB_URL=jdbc:mysql://mysql:3306/campus_hub?createDatabaseIfNotExist=true&useUnicode=true&characterEncoding=UTF-8&useSSL=false&allowPublicKeyRetrieval=true
DB_USERNAME=campus_user
DB_PASSWORD=campus_secret
```

> **Lưu ý:** File `.env` đã được đưa vào `.gitignore` để bảo mật, không được đưa thông tin nhạy cảm thật lên repository.

### 3. Đóng gói và khởi chạy hệ thống

**Bước 1: Chạy kiểm thử mã nguồn backend**
```powershell
.\gradlew.bat test
```

**Bước 2: Build Docker Image backend (độc lập)**
```powershell
docker build -t campus-hub-backend .
```

**Bước 3: Khởi chạy toàn bộ hệ thống bằng Docker Compose**
```powershell
docker compose up -d --build
```

**Bước 4: Kiểm tra trạng thái các container**
```powershell
docker compose ps
```

### 4. Kiểm tra sức khỏe hệ thống (Health Check)
Ứng dụng Spring Boot tích hợp sẵn endpoint kiểm tra sức khỏe tại:
- **URL**: [http://localhost:8080/actuator/health](http://localhost:8080/actuator/health)
- **Kiểm tra qua PowerShell**:
```powershell
curl.exe -i http://localhost:8080/actuator/health
# Hoặc dùng Invoke-RestMethod:
Invoke-RestMethod -Uri http://localhost:8080/actuator/health
```
- **Kết quả mong đợi**: HTTP 200 OK với body JSON chứa `"status":"UP"`.

### 5. Xem log và dừng hệ thống

- Xem log service backend:
```powershell
docker compose logs -f backend
```
- Xem log service MySQL:
```powershell
docker compose logs -f mysql
```
- Dừng toàn bộ hệ thống:
```powershell
docker compose down
```
- Dừng hệ thống và xóa volume dữ liệu (nếu muốn reset sạch DB):
```powershell
docker compose down -v
```

### 6. Hình ảnh minh chứng kết quả thực hiện

*(Dán các ảnh chụp màn hình minh chứng vào thư mục `screenshots/` và liên kết tại đây)*

#### Minh chứng 1: Docker Image được build thành công (`docker images`)
![Docker Images](screenshots/docker images.png)

#### Minh chứng 2: Các container đang hoạt động khỏe mạnh (`docker compose ps`)
![Docker Compose PS](screenshots/02-docker-compose-ps.png)

#### Minh chứng 3: Endpoint Health check trả về UP 200 OK
![Actuator Health Check](screenshots/03-actuator-health.png)

