FROM debian:bullseye-slim
LABEL author="King-Snakes" maintainer="MexicanKingSnakes@gmail.com"

ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_DIR=/opt/java

# Install dependencies and create container user
RUN apt-get update -y && apt-get install -y \
    bash lsof curl jq unzip tar file ca-certificates openssl git \
    sqlite3 fontconfig libfreetype6 tzdata iproute2 libstdc++6 && \
    mkdir -p /opt/java && useradd -m -d /home/container container

# Java 8
RUN curl -fsSL -o /tmp/java8.tar.gz https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u392-b08/OpenJDK8U-jdk_aarch64_linux_hotspot_8u392b08.tar.gz && \
    mkdir -p /opt/java/java8 && \
    tar -xzf /tmp/java8.tar.gz --strip-components=1 -C /opt/java/java8 && \
    rm /tmp/java8.tar.gz

# Java 11
RUN curl -fsSL -o /tmp/java11.tar.gz https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.22+7/OpenJDK11U-jdk_aarch64_linux_hotspot_11.0.22_7.tar.gz && \
    mkdir -p /opt/java/java11 && \
    tar -xzf /tmp/java11.tar.gz --strip-components=1 -C /opt/java/java11 && \
    rm /tmp/java11.tar.gz

# Java 16
RUN curl -fsSL -o /tmp/java16.tar.gz https://github.com/adoptium/temurin16-binaries/releases/download/jdk-16.0.2+7/OpenJDK16U-jdk_aarch64_linux_hotspot_16.0.2_7.tar.gz && \
    mkdir -p /opt/java/java16 && \
    tar -xzf /tmp/java16.tar.gz --strip-components=1 -C /opt/java/java16 && \
    rm /tmp/java16.tar.gz

# Java 17
RUN curl -fsSL -o /tmp/java17.tar.gz https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.10+7/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.10_7.tar.gz && \
    mkdir -p /opt/java/java17 && \
    tar -xzf /tmp/java17.tar.gz --strip-components=1 -C /opt/java/java17 && \
    rm /tmp/java17.tar.gz

# Java 21
RUN curl -fsSL -o /tmp/java21.tar.gz https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.2+13/OpenJDK21U-jdk_aarch64_linux_hotspot_21.0.2_13.tar.gz && \
    mkdir -p /opt/java/java21 && \
    tar -xzf /tmp/java21.tar.gz --strip-components=1 -C /opt/java/java21 && \
    rm /tmp/java21.tar.gz

# Java 22
RUN curl -fsSL -o /tmp/java22.tar.gz https://github.com/adoptium/temurin22-binaries/releases/download/jdk-22+36/OpenJDK22U-jdk_aarch64_linux_hotspot_22_36.tar.gz && \
    mkdir -p /opt/java/java22 && \
    tar -xzf /tmp/java22.tar.gz --strip-components=1 -C /opt/java/java22 && \
    rm /tmp/java22.tar.gz

# Final setup
USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
