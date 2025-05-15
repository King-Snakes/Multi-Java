FROM alpine:3.20

LABEL author="King-Snakes" maintainer="MexicanKingSnakes@gmail.com"

ARG JAVA_VERSIONS="8 11 16 17 21 22"
ENV JAVA_DIR=/opt/java HOME=/home/container

# Bring in entrypoint.sh already owned+executable by 'container'
COPY --chown=container:container --chmod=0755 entrypoint.sh /entrypoint.sh

RUN apk add --no-cache \
      bash lsof curl jq unzip tar file ca-certificates openssl git \
      sqlite sqlite-libs fontconfig ttf-freefont tzdata iproute2 \
      openjdk8-jre-base openjdk11-jre-headless \
      --repository https://dl-cdn.alpinelinux.org/alpine/edge/community openjdk16-jdk \
      openjdk17-jre-headless openjdk21-jre-headless \
      --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing openjdk22-jre-headless && \
    mkdir -p "$JAVA_DIR" && \
    for v in $JAVA_VERSIONS; do \
      mv /usr/lib/jvm/*${v}*-openjdk "$JAVA_DIR/java$v"; \
    done && \
    adduser -D -h "$HOME" container && \
    chown -R container:container "$JAVA_DIR"

USER container
WORKDIR $HOME

ENTRYPOINT ["/entrypoint.sh"]
