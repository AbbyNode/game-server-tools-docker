FROM alpine:latest
RUN apk add --no-cache bash

WORKDIR /setup

COPY ./templates /templates
COPY ./scripts-src /scripts-src
COPY ./docker-compose.yml .
COPY ./init.sh .

ENTRYPOINT ["./init.sh"]
