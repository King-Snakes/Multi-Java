#!/usr/bin/env bash
set -Eeuo pipefail

# ─── 0) PRIME A DEFAULT JAVA FOR THE INSTALL ──────────────────────────────────
export JAVA_HOME="${JAVA_DIR}/java${JAVA_VERSION}"
export PATH="${JAVA_HOME}/bin:${PATH}"

# ─── 1) INSTALL PHASE ──────────────────────────────────────────────────────────
# Pterodactyl invokes: /entrypoint.sh /mnt/install/install.sh [args]
if [[ $# -gt 0 && -f "$1" && "${1##*/}" == "install.sh" ]]; then
  exec bash "$@"
fi

# ─── 2) START PHASE ────────────────────────────────────────────────────────────
cd /home/container

# 2.1) Pick the version recorded by installer (or fall back to default)
JAVA_VER=$(cat .javaver 2>/dev/null || echo "${JAVA_VERSION}")
export JAVA_HOME="${JAVA_DIR}/java${JAVA_VER}"
export PATH="${JAVA_HOME}/bin:${PATH}"

# 2.2) Diagnostics (optional)
echo "Using JAVA_HOME: $JAVA_HOME"
printf "\033[1m\033[33mcontainer@pterodactyl~ \033[0mjava -version\n"
java -version

# 2.3) Preserve timezone & internal Docker IP
export TZ=${TZ:-UTC}
export INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')

# 2.4) Expand Pterodactyl’s STARTUP template
PARSED=$(echo "${STARTUP}"         \
  | sed -e 's/{{/${/g' -e 's/}}/}/g' \
  | eval echo "\$(cat -)")
printf "\033[1m\033[33mcontainer@pterodactyl~ \033[0m%s\n" "$PARSED"

# ─── 3) LAUNCH ─────────────────────────────────────────────────────────────────
# Try to drop privileges to 'container'; if that fails, run as root
if su-exec container:container env ${PARSED}; then
  exit 0
else
  echo "Warning: su-exec failed, launching as root"
  exec env ${PARSED}
fi
