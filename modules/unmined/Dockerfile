# https://unmined.net/

FROM mcr.microsoft.com/dotnet/runtime:9.0-alpine
RUN apk add --no-cache bash curl ca-certificates \
    && update-ca-certificates

WORKDIR /unmined

# Download and extract uNmINeD CLI
RUN curl -L -o unmined-cli.tar.gz "https://unmined.net/download/unmined-cli-linux-musl-x64-dev/" && \
    tar -xzf unmined-cli.tar.gz && \
    rm unmined-cli.tar.gz && \
    chmod +x unmined-cli_*/unmined-cli

COPY ./scripts /scripts
RUN chmod +x /scripts/*.sh

ENTRYPOINT ["/scripts/entrypoint.sh"]
