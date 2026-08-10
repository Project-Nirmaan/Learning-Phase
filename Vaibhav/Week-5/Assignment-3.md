# Assignment 3: Automated Backup Script

Script must:

- Accept directory argument
- Validate input
- Create timestamped archive
- Handle errors
- Log actions

---

## Assignment Breakdown

- C → Create script
- A → Handle arguments and control flow
- V → Validate input
- T → Create archive with timestamp
- F → Handle errors
- O → Log actions
- X → Explain script design

---

## Step-by-Step Execution

### C → Entity Creation (Script)

```shell
cat << 'EOF' > backup.sh
#!/bin/bash

set -e
set -o pipefail

LOG_FILE=backup.log

log() {
echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOG_FILE
}

validate_input() {
if [ -z "$1" ]; then
log "ERROR: No directory provided"
exit 1
fi

    if [ ! -d "$1" ]; then
        log "ERROR: Provided path is not a directory"
        exit 1
    fi
}

create_backup() {
DIR=$1
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
ARCHIVE="backup_${TIMESTAMP}.tar.gz"

    log "Creating archive $ARCHIVE"
    tar -czf "$ARCHIVE" "$DIR"
}

main() {
validate_input "$1"
create_backup "$1"
log "Backup completed successfully"
}

main "$1"
EOF

chmod +x backup.sh
```

---

### T → Execute Script

```bash
./backup.sh test_directory
```

Expected Output:

```bash
2026-04-11 12:00:00 - Creating archive backup_20260411_120000.tar.gz
2026-04-11 12:00:01 - Backup completed successfully
```

---

## D → Differentiation

- Valid input → backup created successfully
- Missing or invalid input → script exits with error
- Logs track execution steps and errors

---

## Explanation

### Argument Handling

The script accepts a directory as input using positional parameters. This allows flexibility to back up any directory
provided by the user.

---

### Input Validation

Before performing any operation, the script checks whether the argument is provided and whether it is a valid directory.
This prevents runtime errors and ensures correct usage.

---

### Timestamped Archive

A timestamp is added to the archive name to ensure uniqueness and prevent overwriting previous backups. This also helps
in tracking when backups were created.

---

### Error Handling

Using set -e and set -o pipefail ensures that the script stops immediately if any command fails. Additionally,
validation functions explicitly handle incorrect input scenarios.

---

### Logging

The log function records all actions with timestamps. This helps in auditing and debugging by maintaining a history of
operations performed by the script.