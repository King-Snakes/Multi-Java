FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_DIR=/opt/java

RUN apt-get update && \
    apt-get install -y curl ca-certificates tar bash tzdata && \
    mkdir -p ${JAVA_DIR}

# Java 8
RUN curl -L -o /tmp/java8.tar.gz https://github.com/adoptium/temurin8-binaries/releases/download/OpenJDK8U-jdk_aarch64_linux_hotspot_8u402b06/OpenJDK8U-jdk_aarch64_linux_hotspot_8u402b06.tar.gz && \
    mkdir -p ${JAVA_DIR}/java8 && \
    tar -xzf /tmp/java8.tar.gz --strip-components=1 -C ${JAVA_DIR}/java8 && \
    rm /tmp/java8.tar.gz

# Java 11
RUN curl -L -o /tmp/java11.tar.gz https://github.com/adoptium/temurin11-binaries/releases/download/OpenJDK11U-jdk_aarch64_linux_hotspot_11.0.22_7/OpenJDK11U-jdk_aarch64_linux_hotspot_11.0.22_7.tar.gz && \
    mkdir -p ${JAVA_DIR}/java11 && \
    tar -xzf /tmp/java11.tar.gz --strip-components=1 -C ${JAVA_DIR}/java11 && \
    rm /tmp/java11.tar.gz

# Java 16
RUN curl -L -o /tmp/java16.tar.gz https://github.com/adoptium/temurin16-binaries/releases/download/OpenJDK16U-jdk_aarch64_linux_hotspot_16.0.2_7/OpenJDK16U-jdk_aarch64_linux_hotspot_16.0.2_7.tar.gz && \
    mkdir -p ${JAVA_DIR}/java16 && \
    tar -xzf /tmp/java16.tar.gz --strip-components=1 -C ${JAVA_DIR}/java16 && \
    rm /tmp/java16.tar.gz

# Java 17
RUN curl -L -o /tmp/java17.tar.gz https://github.com/adoptium/temurin17-binaries/releases/download/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.10_7/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.10_7.tar.gz && \
    mkdir -p ${JAVA_DIR}/java17 && \
    tar -xzf /tmp/java17.tar.gz --strip-components=1 -C ${JAVA_DIR}/java17 && \
    rm /tmp/java17.tar.gz

# Java 21
RUN curl -L -o /tmp/java21.tar.gz https://github.com/adoptium/temurin21-binaries/releases/download/OpenJDK21U-jdk_aarch64_linux_hotspot_21.0.2_13/OpenJDK21U-jdk_aarch64_linux_hotspot_21.0.2_13.tar.gz && \
    mkdir -p ${JAVA_DIR}/java21 && \
    tar -xzf /tmp/java21.tar.gz --strip-components=1 -C ${JAVA_DIR}/java21 && \
    rm /tmp/java21.tar.gz

# Java 22
RUN curl -L -o /tmp/java22.tar.gz https://github.com/adoptium/temurin22-binaries/releases/download/OpenJDK22U-jdk_aarch64_linux_hotspot_22_36/OpenJDK22U-jdk_aarch64_linux_hotspot_22_36.tar.gz && \
    mkdir -p ${JAVA_DIR}/java22 && \
    tar -xzf /tmp/java22.tar.gz --strip-components=1 -C ${JAVA_DIR}/java22 && \
    rm /tmp/java22.tar.gz

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /mnt/server
ENTRYPOINT ["/entrypoint.sh"]