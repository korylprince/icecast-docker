FROM golang:1-alpine as builder

ARG VERSION

RUN go install github.com/korylprince/fileenv@v1.1.0

FROM alpine:3.17

RUN apk add --no-cache bash icecast gettext mailcap

COPY --from=builder /go/bin/fileenv /

RUN chown -R icecast:icecast /usr/share/icecast /var/log/icecast

COPY icecast.xml /etc/icecast.xml.tmpl
COPY run.sh /

CMD ["/fileenv", "bash", "/run.sh"]
