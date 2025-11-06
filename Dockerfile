FROM alpine:latest
RUN apk add --no-cache bash

COPY ./scripts /scripts
RUN chmod +x /scripts/*.sh

COPY ./templates /templates
COPY ./docker-compose.yml /templates/docker-compose.yml

ENTRYPOINT ["/scripts/init.sh"]
