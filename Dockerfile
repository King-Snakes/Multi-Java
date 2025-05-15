FROM alpine:3.20

LABEL author="King-Snakes" maintainer="MexicanKingSnakes@gmail.com"

# Java versions, directory, and unprivileged user
ENV JAVA_VERSIONS="8 11 16 17 21 22" \
    JAVA_DIR=/opt/java \
    USER=container \
    HOME=/home/container

# Copy entrypoint early so we can chmod it in the same layer
COPY entrypoint.sh /entrypoint.sh

RUN apk add --no-cache \
      bash lsof curl jq unzip tar file ca-certificates openssl git \
      sqlite sqlite-libs fontconfig ttf-freefont tzdata iproute2 \
      openjdk8-jre-base openjdk11-jre-headless \
      --repository https://dl-cdn.alpinelinux.org/alpine/edge/community \
        openjdk16-jre-headless \
      openjdk17-jre-headless openjdk21-jre-headless \
      --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing \
        openjdk22-jre-headless && \
    mkdir -p "${JAVA_DIR}" && \
    for v in $JAVA_VERSIONS; do \
      mv /usr/lib/jvm/*${v}*-openjdk "${JAVA_DIR}/java${v}"; \
    done && \
    adduser -D -h "$HOME" "$USER" && \
    chown -R "$USER":"$USER" "${JAVA_DIR}" /entrypoint.sh && \
    chmod +x /entrypoint.sh

USER container
WORKDIR $HOME

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
