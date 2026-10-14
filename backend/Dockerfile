# Stage 1: Build mã nguồn bằng JDK 21 và Gradle Wrapper
FROM eclipse-temurin:21-jdk AS builder
WORKDIR /app

# Copy Gradle wrapper và các file khai báo dependency
COPY gradlew .
COPY gradle ./gradle
COPY build.gradle settings.gradle ./

# Cấp quyền thực thi cho Gradle wrapper script
RUN chmod +x gradlew

# Copy toàn bộ mã nguồn
COPY src ./src

# Build ứng dụng thành file JAR (bỏ qua test khi đóng gói để tiết kiệm thời gian)
RUN ./gradlew bootJar -x test --no-daemon

# Stage 2: Chạy ứng dụng bằng JRE 21 gọn nhẹ
FROM eclipse-temurin:21-jre
WORKDIR /app

# Copy file JAR được build từ stage trước
COPY --from=builder /app/build/libs/*.jar app.jar

# Mở cổng mặc định của Spring Boot
EXPOSE 8080

# Chạy ứng dụng
ENTRYPOINT ["java", "-jar", "app.jar"]
