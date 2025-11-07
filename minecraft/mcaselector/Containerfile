FROM eclipse-temurin:25-jre-alpine

# Install bash, curl, jq
RUN apk add --no-cache bash curl jq

WORKDIR /mcaselector

# Download latest MCSelector release
RUN echo "Fetching latest MCSelector release URL" && \
    latest_url=$( \
        curl -fsSL "https://api.github.com/repos/Querz/mcaselector/releases/latest" | \
        jq -r '.assets[] | select(.name | endswith(".jar")) | .browser_download_url' \
    ) && \
    echo "Downloading MCSelector from $latest_url" && \
    curl -fsSL -o mcaselector.jar "$latest_url" && \
    echo "Setting execute permissions" && \
    chmod +x mcaselector.jar

ENTRYPOINT ["java", "-jar", "mcaselector.jar"]
