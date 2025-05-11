#!/bin/bash
set -e

# Set timezone (default to UTC) and internal IP
export TZ="${TZ:-UTC}"
export INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2); exit}')

# Activate Java version
JAVA_VER=$(cat /mnt/server/.javaver 2>/dev/null || echo "22")
export JAVA_HOME="/opt/java/java${JAVA_VER}"
export PATH="$JAVA_HOME/bin:$PATH"
echo "Using JAVA_HOME: $JAVA_HOME"
java -version

# Change to container's working directory
cd /home/container || exit 1

# Prepare and run startup command
PARSED=$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g' | eval echo "$(cat -)")
printf "\033[1m\033[33mcontainer@pterodactyl~ \033[0m%s\n" "$PARSED"
exec env ${PARSED}