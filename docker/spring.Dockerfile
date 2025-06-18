FROM gradle:8.5-jdk21 AS builder
WORKDIR /app
COPY apps/time .
RUN gradle bootJar --no-daemon

FROM openjdk:21-jdk-slim

WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
