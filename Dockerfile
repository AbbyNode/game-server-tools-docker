FROM eclipse-temurin:25-jre-alpine

RUN apk add --no-cache wget unzip
    
WORKDIR /minecraft

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
