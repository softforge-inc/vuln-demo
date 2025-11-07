# Dockerfile (INTENTIONALLY VULNERABLE — demo only)
FROM gradle:4.10-jdk8
USER root
ENV APP_SECRET="SuperSecret123!"
ENV JAVA_TOOL_OPTIONS="-Xmx512m"
ADD http://example.com/unknown-tool.sh /usr/local/bin/unknown-tool.sh
RUN chmod +x /usr/local/bin/unknown-tool.sh || true
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl wget netcat \
 && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY build.gradle settings.gradle /app/
RUN gradle --no-daemon dependencies || true
COPY src /app/src
RUN gradle --no-daemon clean build || true
EXPOSE 8080
CMD ["sh", "-c", "java -jar build/libs/${PROJECT_NAME:-app}.jar || java -jar build/libs/*all*.jar || java -jar build/libs/*.jar"]
