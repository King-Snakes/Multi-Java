FROM debian:bullseye-slim

ENV JAVA_DIR=/opt/java
ENV PATH=$JAVA_DIR/java17/bin:$PATH

RUN apt-get update && apt-get install -y curl tar bash ca-certificates tzdata iproute2 && \
    mkdir -p $JAVA_DIR

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN useradd -d /home/container -m container
USER container
WORKDIR /home/container

ENTRYPOINT ["/entrypoint.sh"]
