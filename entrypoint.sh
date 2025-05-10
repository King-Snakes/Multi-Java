#!/bin/bash
set -e

# Apply correct Java version from .javaver if it exists
if [[ -f .javaver ]]; then
    export JAVA_HOME="/opt/java/java$(cat .javaver)"
    export PATH="$JAVA_HOME/bin:$PATH"
    echo "Activated JAVA_HOME: $JAVA_HOME"
    java -version
fi

# Check startup string
if [ -z "${STARTUP}" ]; then
    echo "STARTUP variable is not set."
    exit 1
fi

PARSED=$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g' | eval echo "$(cat -)")
echo "Running startup command:"
echo "${PARSED}"

exec env ${PARSED}