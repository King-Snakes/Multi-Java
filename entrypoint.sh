#!/usr/bin/env bash
set -Eeuo pipefail

export JAVA_HOME="${JAVA_DIR}/java${JAVA_VERSION}"
export PATH="${JAVA_HOME}/bin:${PATH}"

if [[ $# -gt 0 && -f "$1" && "${1##*/}" == "install.sh" ]]; then
  exec bash "$@"
fi

cd /home/container

JAVA_VER=$(cat .javaver 2>/dev/null || echo "${JAVA_VERSION}")
export JAVA_HOME="${JAVA_DIR}/java${JAVA_VER}"
export PATH="${JAVA_HOME}/bin:${PATH}"

echo "Using JAVA_HOME: $JAVA_HOME"
printf "\033[1m\033[33mcontainer@pterodactyl~ \033[0mjava -version\n"
java -version

export TZ=${TZ:-UTC}
export INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')

PARSED=$(echo "${STARTUP}"         \
  | sed -e 's/{{/${/g' -e 's/}}/}/g' \
  | eval echo "\$(cat -)")
printf "\033[1m\033[33mcontainer@pterodactyl~ \033[0m%s\n" "$PARSED"

exec su-exec container:container env ${PARSED}
