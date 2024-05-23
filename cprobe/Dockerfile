FROM currycan/alpine:3

WORKDIR /app

ENV CPROBE_VERSION=0.11.0

RUN set -ex; \
    curl -sSL https://github.com/cprobe/cprobe/releases/download/v${CPROBE_VERSION}/cprobe-v${CPROBE_VERSION}-linux-amd64.tar.gz -o /tmp/cprobe.tar.gz; \
    tar -zxf /tmp/cprobe.tar.gz -C /tmp --strip-components=1; \
    mv /tmp/cprobe /usr/bin; \
    mv /tmp/conf.d /app; \
    rm -rf /tmp/*

EXPOSE 5858

CMD ["cprobe", "-conf.d", "/app/conf.d"]
