FROM golang:1.11.5-alpine3.9 AS builder
RUN apk add --no-cache git
RUN go get -v github.com/adnanh/webhook
RUN go get -v github.com/spf13/hugo

FROM alpine:3.9
RUN apk add --no-cache bash git && rm -rf /var/cache/apk/*
COPY --from=builder /go/bin/ /usr/local/bin/

COPY hooks.json /etc/webhook/hooks.json
COPY run.sh /run.sh

EXPOSE 9000
ENTRYPOINT ["/bin/bash", "/run.sh"]
CMD ["run"]
