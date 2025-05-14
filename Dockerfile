
FROM debian:bullseye-slim
LABEL author="King-Snakes" maintainer="MexicanKingSnakes@gmail.com"

ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_DIR=/opt/java

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash lsof curl jq unzip tar file ca-certificates openssl git \
    sqlite3 fontconfig libfreetype6 tzdata iproute2 libstdc++6 && \
    rm -rf /var/lib/apt/lists/*


# Multi-arch Java install
ARG ARCH="$(dpkg --print-architecture)"
RUN for V in 8 11 16 17 21 22; do \
      mkdir -p /opt/java/java${V}; \
      case "$ARCH" in \
        amd64) url="https://github.com/adoptium/temurin${V}-binaries/releases/download/jdk-${V}.0.0+0/OpenJDK${V}U-jdk_x64_linux_hotspot_${V}.0.0_0.tar.gz" ;; \
        arm64) url="https://github.com/adoptium/temurin${V}-binaries/releases/download/jdk-${V}.0.0+0/OpenJDK${V}U-jdk_aarch64_linux_hotspot_${V}.0.0_0.tar.gz" ;; \
        *) echo "Unsupported arch: $ARCH" && exit 1 ;; \
      esac; \
      curl -fsSL "$url" -o /tmp/java${V}.tar.gz; \
      tar -xzf /tmp/java${V}.tar.gz --strip-components=1 -C /opt/java/java${V}; \
      rm /tmp/java${V}.tar.gz; \
    done


# Create container user
RUN useradd -m -d /home/container container && \
    chown -R container:container /opt/java

# Copy and set permissions for entrypoint
COPY --chown=container:container entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER container
WORKDIR /home/container

ENV USER=container HOME=/home/container

CMD ["/bin/bash", "/entrypoint.sh"]
