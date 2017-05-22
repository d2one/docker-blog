FROM        alpine

ENV         GOPATH /go
ENV         WEBHOOKPATH ${GOPATH}/src/github.com/adnanh/webhook
ENV         HUGOPATH ${GOPATH}/src/github.com/spf13/hugo

RUN         apk add --no-cache --update -t build-deps go libc-dev gcc libgcc && mkdir -p ${WEBHOOKPATH} && mkdir -p ${HUGOPATH}
RUN         apk add --no-cache git bash

RUN         git clone https://github.com/adnanh/webhook.git ${WEBHOOKPATH} && \
            cd ${WEBHOOKPATH} && go get && go build -o /usr/local/bin/webhook

RUN         git clone https://github.com/spf13/hugo.git ${HUGOPATH} && \
            cd ${HUGOPATH} && go get && go build -o /usr/local/bin/hugo

RUN         rm -rf ${GOPATH} && rm -rf /var/cache/apk/* && apk del build-deps

COPY 		hooks.json /etc/webhook/hooks.json
COPY 		run.sh /run.sh

EXPOSE      9000
ENTRYPOINT  ["/bin/bash", "/run.sh"]
CMD         ["run"]

