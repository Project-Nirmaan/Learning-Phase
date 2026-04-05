#!/bin/bash

# Week 5 build script.
# Compiles C source and moves binary to bin/.

set -e
set -o pipefail

SOURCE_FILE="src/hello.c"
OUTPUT_BINARY="hello"
BIN_DIR="bin"

if [[ ! -f "${SOURCE_FILE}" ]]; then
  echo "[ERROR] Source file not found: ${SOURCE_FILE}" >&2
  exit 1
fi

echo "[STEP] Compiling ${SOURCE_FILE}"
gcc "${SOURCE_FILE}" -o "${OUTPUT_BINARY}"

mkdir -p "${BIN_DIR}"
mv "${OUTPUT_BINARY}" "${BIN_DIR}/"

echo "[DONE] Build successful. Binary available at ${BIN_DIR}/${OUTPUT_BINARY}"
