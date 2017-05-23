FROM golang:1.8-alpine

RUN apk update && apk upgrade && \
    apk add --no-cache git && rm -rf /var/cache/apk/*

RUN go get -v github.com/adnanh/webhook
RUN go get -v github.com/spf13/hugo

FROM alpine
RUN apk update && apk upgrade && \
    apk add --no-cache bash git && rm -rf /var/cache/apk/*

COPY --from=0 /go/bin/webhook /usr/local/bin/webhook
COPY --from=0 /go/bin/hugo /usr/local/bin/hugo

COPY hooks.json /etc/webhook/hooks.json
COPY run.sh /run.sh

EXPOSE 9000
ENTRYPOINT ["/bin/bash", "/run.sh"]
CMD ["run"]

