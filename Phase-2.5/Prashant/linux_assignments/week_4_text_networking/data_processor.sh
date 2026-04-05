#!/bin/bash

# Week 4 CSV processor.
# Calculates average response time and average CPU usage from metrics.csv.

set -euo pipefail

CSV_FILE="metrics.csv"

if [[ ! -f "${CSV_FILE}" ]]; then
  echo "[ERROR] Missing CSV file: ${CSV_FILE}" >&2
  exit 1
fi

awk -F',' '
NR == 1 { next }
{
  response_sum += $2
  cpu_sum += $3
  count += 1
}
END {
  if (count == 0) {
    print "[WARN] No data rows found."
    exit 0
  }

  printf "Average response_time_ms: %.2f\n", response_sum / count
  printf "Average cpu_usage_percent: %.2f\n", cpu_sum / count
}
' "${CSV_FILE}"
