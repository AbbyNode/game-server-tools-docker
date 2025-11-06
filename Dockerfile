FROM alpine:latest
RUN apk add --no-cache bash

WORKDIR /setup

COPY ./init.sh .
COPY ./docker-compose.yml .
COPY ./scripts-src /scripts-src
COPY ./templates /templates

ENTRYPOINT ["./init.sh"]
