# Dockerfile tại thư mục gốc đóng gói dịch vụ backend Campus Hub
# Hỗ trợ lệnh: docker build -t campus-hub-backend .

# Stage 1: Build mã nguồn bằng JDK 21
FROM eclipse-temurin:21-jdk AS builder
WORKDIR /app

COPY backend/gradlew .
COPY backend/gradle ./gradle
COPY backend/build.gradle backend/settings.gradle ./

RUN chmod +x gradlew

COPY backend/src ./src

RUN ./gradlew bootJar -x test --no-daemon

# Stage 2: Runtime image gọn nhẹ với JRE 21
FROM eclipse-temurin:21-jre
WORKDIR /app

COPY --from=builder /app/build/libs/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
