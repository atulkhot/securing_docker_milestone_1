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
      https://github.com/gohugoio/hugo/releases/download/v0.64.0/hugo_0.64.0_linux-64bit.tar.gz -o hugo_0.64.0_linux-64bit.tar.gz \
      && curl -L https://github.com/gohugoio/hugo/releases/download/v0.64.0/hugo_0.64.0_checksums.txt -o hugo_0.64.0_checksums.txt \
      && sha256sum hugo_0.64.0_linux-64bit.tar.gz | cut -d ' ' -f1 > c1.txt \
      && egrep hugo_0.64.0_Linux-64bit.tar.gz hugo_0.64.0_checksums.txt | cut -d ' ' -f1 > c2.txt \
      && cmp c1.txt c2.txt \
      && tar -xzf hugo_0.64.0_linux-64bit.tar.gz \
      && mv hugo /usr/local/bin/hugo \
      && addgroup -Sg 1000 hugo \
      && adduser -SG hugo -u 1000 -h /src hugo"
 
WORKDIR /src

COPY orgdocs .

EXPOSE 1313

HEALTHCHECK CMD curl --fail http://localhost:1313 || exit 1

CMD ["hugo", "server", "-w", "--bind=0.0.0.0"]
