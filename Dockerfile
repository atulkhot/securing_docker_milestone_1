FROM alpine:3.18.3

LABEL org.opencontainers.image.authors="psellars@gmail.com"

RUN apk add --no-cache \
    curl \
    git \
    openssh-client \
    rsync

ENV VERSION 0.64.0
WORKDIR /usr/local/src
RUN ash -c "set -o pipefail && curl -L \
      https://github.com/gohugoio/hugo/releases/download/v${VERSION}/hugo_${VERSION}_linux-64bit.tar.gz -o hugo_${VERSION}_linux-64bit.tar.gz \
      && tar -xzf hugo_${VERSION}_linux-64bit.tar.gz \
    && mv hugo /usr/local/bin/hugo \
    && addgroup -Sg 1000 hugo \
    && adduser -SG hugo -u 1000 -h /src hugo"

WORKDIR /src

COPY orgdocs .

EXPOSE 1313

HEALTHCHECK CMD curl --fail http://localhost:1313 || exit 1

CMD ["hugo", "server", "-w", "--bind=0.0.0.0"]
