FROM golang:1.26.1-alpine3.23 AS builder

RUN apk add --no-cache git
RUN go install github.com/adnanh/webhook@2.8.3

FROM alpine:3.23

RUN apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \
    bash git hugo gettext

COPY --from=builder /go/bin/ /usr/local/bin/
COPY hooks.json /etc/webhook/hooks.json
COPY run.sh /run.sh

EXPOSE 9000
ENTRYPOINT ["/bin/bash", "/run.sh"]
CMD ["run"]
