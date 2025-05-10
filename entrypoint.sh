#!/bin/bash
set -e

# Optional: show all installed Java versions
echo "Installed Java versions:"
ls -1 /opt/java || true

# Use egg script or override in server logic
if [ -z "${STARTUP}" ]; then
  echo "STARTUP variable is not set."
  exit 1
fi

# Parse variables in STARTUP
PARSED=$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g' | eval echo "$(cat -)")
echo "Running startup command:"
echo "${PARSED}"

exec env ${PARSED}