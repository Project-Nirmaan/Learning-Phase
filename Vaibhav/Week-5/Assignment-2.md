# Assignment 2: Build Helper Script

## Original Assignment

- Write a script that:
  - Cleans build directory
  - Compiles project
  - Moves binary to `bin/`
  - Prints success/failure based on exit code
- Must use:
  - `set -e`
  - `set -o pipefail`
  - Functions

---

## Building Blocks Breakdown

- C → Create script
- A → Use functions and control flow
- T → Compile and move binary
- F → Handle failure via exit codes
- V → Verify success/failure
- X → Explain script behavior

---

## Step-by-Step Execution

### C → Create script

```shell
cat << 'EOF' > build.sh
#!/bin/bash

set -e
set -o pipefail

BUILD_DIR=build
BIN_DIR=bin
SRC_FILE=hello.c
OUTPUT=hello

clean() {
  echo "[STEP] Cleaning build directory"
  rm -rf $BUILD_DIR
  mkdir -p $BUILD_DIR
}

compile() {
  echo "[STEP] Compiling source"
  gcc -Wall -g $SRC_FILE -o $BUILD_DIR/$OUTPUT
}

move_binary() {
  echo "[STEP] Moving binary to bin/"
  mkdir -p $BIN_DIR
  mv $BUILD_DIR/$OUTPUT $BIN_DIR/
}

main() {
  clean
  compile
  move_binary
  echo "[SUCCESS] Build completed"
}

main
EOF

chmod +x build.sh
```

---

### T → Execute Script

```bash
./build.sh
```

Expected Output:
```bash
[STEP] Cleaning build directory
[STEP] Compiling source
[STEP] Moving binary to bin/
[SUCCESS] Build completed
```

---

## D → Differentiation

- clean removes previous build artifacts
- compile generates binary
- move_binary organizes output
- script stops immediately if any command fails

---

## Explanation

### set -e

set -e ensures that the script exits immediately if any command fails. This prevents the script from continuing in an inconsistent or broken state.

---

### set -o pipefail

This ensures that if any command in a pipeline fails, the entire pipeline is considered failed. Without this, only the last command’s status is checked.

---

### Functions

Functions allow modular and reusable code. Each step like cleaning, compiling, and moving binaries is separated logically, improving readability and maintainability.

---

### Exit Code Handling

The script relies on automatic failure handling via set -e. If any step fails, execution stops and success message is not printed, effectively indicating failure.