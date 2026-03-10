#!/bin/bash

set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCK_FILE="${XDG_RUNTIME_DIR:-/tmp}/plasma-harvest.lock"
STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/plasma-harvest.last"
MIN_INTERVAL_SECONDS=8

exec 9>"${LOCK_FILE}"
if ! flock -n 9; then
    echo "Plasma harvest already running; skipping duplicate trigger"
    exit 0
fi

# Debounce rapid back-to-back path events
now_epoch="$(date +%s)"
if [[ -f "${STATE_FILE}" ]]; then
    last_epoch="$(cat "${STATE_FILE}" 2>/dev/null || echo 0)"
    if [[ "$(( now_epoch - last_epoch ))" -lt "${MIN_INTERVAL_SECONDS}" ]]; then
        echo "Skipping duplicate trigger (debounced)"
        exit 0
    fi
fi

sleep 1

PLASMA_VERSION="${KDE_SESSION_VERSION:-}"

if [[ -z "${PLASMA_VERSION}" ]]; then
    if [[ -d "${SOURCE_DIR}/plasma/v6" ]]; then
        PLASMA_VERSION="6"
    elif [[ -d "${SOURCE_DIR}/plasma/v5" ]]; then
        PLASMA_VERSION="5"
    else
        echo "No plasma layout directories found under ${SOURCE_DIR}/plasma"
        exit 1
    fi
fi

HARVEST_SCRIPT="${SOURCE_DIR}/plasma/v${PLASMA_VERSION}/harvest_layout.sh"
if [[ ! -f "${HARVEST_SCRIPT}" ]]; then
    echo "Harvest script not found: ${HARVEST_SCRIPT}"
    exit 1
fi

/bin/bash "${HARVEST_SCRIPT}"

echo "${now_epoch}" > "${STATE_FILE}"

echo "Auto-harvest complete (Plasma v${PLASMA_VERSION})"
