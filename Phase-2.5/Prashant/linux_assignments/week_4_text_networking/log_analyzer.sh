#!/bin/bash

# Week 4 log analyzer.
# Prints ERROR lines from the last one hour.
# Expected log format:
# YYYY-MM-DD HH:MM:SS LEVEL message

set -euo pipefail

LOG_FILE="app.log"

if [[ ! -f "${LOG_FILE}" ]]; then
  echo "[ERROR] Missing log file: ${LOG_FILE}" >&2
  exit 1
fi

cutoff_epoch="$(date -d '1 hour ago' +%s)"

echo "[INFO] ERROR logs from the last hour:"

while IFS= read -r line; do
  timestamp="${line:0:19}"

  # Skip malformed lines safely.
  if ! line_epoch="$(date -d "${timestamp}" +%s 2>/dev/null)"; then
    continue
  fi

  if (( line_epoch >= cutoff_epoch )) && [[ "${line}" == *"ERROR"* || "${line}" == *" ERROR "* ]]; then
    echo "${line}"
  fi
done < "${LOG_FILE}"
