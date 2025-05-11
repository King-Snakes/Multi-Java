FROM debian:bullseye-slim
LABEL author="King-Snakes" maintainer="MexicanKingSnakes@gmail.com"

ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_DIR=/opt/java

RUN apt-get update -y &&     apt-get install -y --no-install-recommends bash lsof curl jq unzip tar file ca-certificates openssl git sqlite3 fontconfig libfreetype6 tzdata iproute2 libstdc++6 &&     rm -rf /var/lib/apt/lists/* &&     mkdir -p ${JAVA_DIR} &&     useradd -d /home/container -m container

RUN for v in     "8 https://github.com/adoptium/temurin8-binaries/releases/download/OpenJDK8U-jdk_aarch64_linux_hotspot_8u402b06/OpenJDK8U-jdk_aarch64_linux_hotspot_8u402b06.tar.gz"     "11 https://github.com/adoptium/temurin11-binaries/releases/download/OpenJDK11U-jdk_aarch64_linux_hotspot_11.0.22_7/OpenJDK11U-jdk_aarch64_linux_hotspot_11.0.22_7.tar.gz"     "16 https://github.com/adoptium/temurin16-binaries/releases/download/OpenJDK16U-jdk_aarch64_linux_hotspot_16.0.2_7/OpenJDK16U-jdk_aarch64_linux_hotspot_16.0.2_7.tar.gz"     "17 https://github.com/adoptium/temurin17-binaries/releases/download/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.10_7/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.10_7.tar.gz"     "21 https://github.com/adoptium/temurin21-binaries/releases/download/OpenJDK21U-jdk_aarch64_linux_hotspot_21.0.2_13/OpenJDK21U-jdk_aarch64_linux_hotspot_21.0.2_13.tar.gz"     "22 https://github.com/adoptium/temurin22-binaries/releases/download/OpenJDK22U-jdk_aarch64_linux_hotspot_22_36/OpenJDK22U-jdk_aarch64_linux_hotspot_22_36.tar.gz";     do         ver=$(echo $v | cut -d' ' -f1);         url=$(echo $v | cut -d' ' -f2);         mkdir -p ${JAVA_DIR}/java$ver &&         curl -fsSL "$url" -o /tmp/java$ver.tar.gz &&         tar -xzf /tmp/java$ver.tar.gz --strip-components=1 -C ${JAVA_DIR}/java$ver &&         rm /tmp/java$ver.tar.gz;     done

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container
COPY        entrypoint.sh /entrypoint.sh
RUN         chmod +x /entrypoint.sh
ENTRYPOINT  ["/entrypoint.sh"]