#!/bin/bash

# Week 3 stream pipeline demo.
# Finds unique ERROR messages from the demo log.

set -euo pipefail

LOG_FILE="demo_app.log"

if [[ ! -f "${LOG_FILE}" ]]; then
  echo "[ERROR] Log file not found: ${LOG_FILE}" >&2
  exit 1
fi

echo "[INFO] Unique ERROR messages in ${LOG_FILE}:"

# Pipeline explanation:
# 1) grep lines with ERROR
# 2) awk extracts message after 'ERROR '
# 3) sort groups same messages together
# 4) uniq prints each distinct message once
grep "ERROR" "${LOG_FILE}" \
  | awk -F "ERROR " '{print $2}' \
  | sort \
  | uniq
