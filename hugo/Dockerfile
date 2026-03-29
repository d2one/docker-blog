FROM golang:1.26.1-alpine3.23 AS builder

RUN apk add --no-cache git
RUN go install github.com/adnanh/webhook@2.8.3

FROM alpine:3.23

ARG HUGO_VERSION=0.159.1
RUN apk add --no-cache bash git wget libc6-compat libstdc++ && \
    wget -O /tmp/hugo.tar.gz "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz" && \
    tar -xzf /tmp/hugo.tar.gz -C /usr/local/bin/ hugo && \
    rm /tmp/hugo.tar.gz && \
    chmod +x /usr/local/bin/hugo

COPY --from=builder /go/bin/ /usr/local/bin/
COPY hooks.json /etc/webhook/hooks.json
COPY run.sh /run.sh

EXPOSE 9000
ENTRYPOINT ["/bin/bash", "/run.sh"]
CMD ["run"]
