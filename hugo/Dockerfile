FROM golang:1.11.5-alpine3.9 AS builder

RUN apk add --no-cache git
# Install pygments (for syntax highlighting) and bash
RUN apk update && apk add py-pygments && apk add bash && rm -rf /var/cache/apk/*

# Download and Install hugo
RUN mkdir /usr/local/hugo
ADD https://github.com/spf13/hugo/releases/download/v0.54.0/hugo_0.54.0_linux-64bit.tar.gz /usr/local/hugo/
RUN tar xzf /usr/local/hugo/hugo_0.54.0_linux-64bit.tar.gz -C /usr/local/hugo/

RUN go get -v github.com/adnanh/webhook

FROM alpine:3.9
RUN apk add --no-cache bash git && rm -rf /var/cache/apk/*
COPY --from=builder /usr/local/hugo/hugo /usr/local/bin/
COPY --from=builder /go/bin/ /usr/local/bin/

COPY hooks.json /etc/webhook/hooks.json
COPY run.sh /run.sh

EXPOSE 9000
ENTRYPOINT ["/bin/bash", "/run.sh"]
CMD ["run"]
