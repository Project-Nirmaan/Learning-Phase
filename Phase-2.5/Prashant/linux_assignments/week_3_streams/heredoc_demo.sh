#!/bin/bash

# Sample Heredoc script for Week 3.
# Generates a small config file using a clean multi-line input block.

set -euo pipefail

cat <<'EOF' > app.conf
APP_NAME=LinuxPracticalDemo
APP_ENV=development
LOG_LEVEL=INFO
MAX_RETRIES=3
EOF

echo "[DONE] Created app.conf using Heredoc."
