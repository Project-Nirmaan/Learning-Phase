#!/bin/bash

# Inode and link demo for Week 1.
# This script creates a file, a hard link, and a soft link,
# then shows inode behavior and permission changes.

set -euo pipefail

WORKDIR="inode_demo_workspace"

echo "[INFO] Preparing demo workspace: ${WORKDIR}"
rm -rf "${WORKDIR}"
mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

echo "Linux practical content" > original.txt

# Create hard and soft links.
ln original.txt hard_link.txt
ln -s original.txt soft_link.txt

echo
 echo "[STEP] Inode numbers (notice original and hard link share inode):"
ls -li original.txt hard_link.txt soft_link.txt

echo
 echo "[STEP] Link count and file details:"
stat original.txt hard_link.txt soft_link.txt

echo
 echo "[STEP] Changing permissions on original file to 640"
chmod 640 original.txt
ls -l original.txt hard_link.txt soft_link.txt

echo
 echo "[STEP] Appending content using hard link"
echo "Added through hard_link.txt" >> hard_link.txt

echo
 echo "[STEP] Reading via original and soft link"
cat original.txt
cat soft_link.txt

echo
 echo "[DONE] Demo complete. Clean up manually if needed: rm -rf ${WORKDIR}"
