FROM alpine:3.18

LABEL author="King-Snakes" maintainer="MexicanKingSnakes@gmail.com"

ENV JAVA_DIR=/opt/java

# Install hotspot headless JREs and essential tools (slim runtime)
RUN apk add --no-cache \
    bash lsof curl jq unzip tar file ca-certificates openssl git \
    sqlite sqlite-libs fontconfig ttf-freefont tzdata iproute2 \
    openjdk8-jre-headless openjdk11-jre-headless openjdk16-jre-headless \
    openjdk17-jre-headless openjdk21-jre-headless openjdk22-jre-headless

# Organize Java installs under /opt/java
RUN for v in 8 11 16 17 21 22; do \
      mkdir -p "${JAVA_DIR}/java${v}"; \
      mv "/usr/lib/jvm/java-${v}-openjdk" "${JAVA_DIR}/java${v}"; \
    done \
 && chown -R root:root "${JAVA_DIR}"

# Create the unprivileged 'container' user
RUN adduser -D -h /home/container container \
 && chown -R container:container "${JAVA_DIR}"

USER container
WORKDIR /home/container

# Copy entrypoint and set execute permissions
COPY --chown=container:container entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Env for Pterodactyl
ENV USER=container HOME=/home/container

CMD ["/bin/sh", "/entrypoint.sh"]
