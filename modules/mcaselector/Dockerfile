# https://github.com/Querz/mcaselector

FROM eclipse-temurin:25-jre-alpine
RUN apk add --no-cache bash curl jq

WORKDIR /mcaselector

# Download latest MCSelector release
RUN latest_url=$(curl -s "https://api.github.com/repos/Querz/mcaselector/releases/latest" \
    | jq -r '.assets[] | select(.name | endswith(".jar")) | .browser_download_url') && \
    echo "Downloading MCSelector from $latest_url" && \
    curl -L "$latest_url" -o mcaselector.jar && \
    chmod +x mcaselector.jar

COPY ./scripts /scripts
RUN chmod +x /scripts/*.sh

COPY ./templates /templates

ENTRYPOINT ["/scripts/entrypoint.sh"]
