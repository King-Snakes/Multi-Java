FROM alpine:3.18
LABEL author="King-Snakes" maintainer="MexicanKingSnakes@gmail.com"

ENV JAVA_DIR=/opt/java \
    HOME=/home/container \
    JAVA_VERSION=22

RUN apk add --no-cache su-exec \
      bash lsof curl jq unzip tar file ca-certificates openssl git \
      sqlite sqlite-libs fontconfig ttf-freefont tzdata iproute2 \
      openjdk8-jre-base openjdk11-jre-headless openjdk16-jre-headless \
      openjdk17-jre-headless \
      --repository https://dl-cdn.alpinelinux.org/alpine/edge/community \
        openjdk21-jre-headless \
      --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing \
        openjdk22-jre-headless && \
    mkdir -p "${JAVA_DIR}" && \
    for d in \
      java-1.8-openjdk java-11-openjdk java-16-openjdk \
      java-17-openjdk java-21-openjdk java-22-openjdk; do \
      v=${d#java-}; v=${v%-openjdk}; v=${v#1.}; \
      mv "/usr/lib/jvm/$d" "${JAVA_DIR}/java$v"; \
    done && \
    adduser -D -h "$HOME" container && \
    chown -R container:container "$JAVA_DIR"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
WORKDIR /home/container
CMD ["/entrypoint.sh"]
