#!/bin/bash

# Week 2 signal demo.
# Starts sleep processes and demonstrates SIGINT vs SIGKILL behavior.

set -euo pipefail

start_sleep() {
  sleep 300 &
  echo $!
}

echo "[STEP] Starting first sleep process"
pid_int="$(start_sleep)"
echo "[INFO] Sleep PID (for SIGINT): ${pid_int}"

sleep 1
kill -SIGINT "${pid_int}"
wait "${pid_int}" || true
echo "[RESULT] SIGINT sent. Process ended gracefully (if app handles it)."

echo
echo "[STEP] Starting second sleep process"
pid_kill="$(start_sleep)"
echo "[INFO] Sleep PID (for SIGKILL): ${pid_kill}"

sleep 1
kill -SIGKILL "${pid_kill}"
wait "${pid_kill}" || true
echo "[RESULT] SIGKILL sent. Process terminated immediately."

echo
echo "[DONE] Signal comparison complete."
