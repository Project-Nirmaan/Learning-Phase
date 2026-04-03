# Assignment 3: Safe Backup Workflow

## 1. Objective

The goal of this assignment is to design and understand a **safe, reliable, and verifiable backup workflow** using Linux tools. The focus is not just on executing commands, but on understanding:

* How backups can fail silently
* How filesystem behavior affects backup correctness
* How to design workflows that ensure **trustworthy backups**

This assignment emphasizes **system thinking over command usage**.

---

## 2. Initial Understanding and Misconceptions

At the beginning, backup was assumed to be:

```bash
tar -czf backup.tar.gz directory/
```

This assumption led to multiple misconceptions:

* Backup completes successfully if command runs
* All files are included by default
* Backup data is consistent
* No need for verification

These assumptions were proven incorrect through experiments.

---

## 3. Experiment 1: Permission Failure

### Setup

* Created directory with multiple files
* Introduced a file with no permissions:

```bash
chmod 000 secrets/secret.key
```

### Observation

```bash
tar -cvf test_backup.tar project_data
```

Output showed:

* Permission denied error
* Backup still continued
* Archive was created

Exit status:

```bash
echo $? → 2
```

### Insight

* `tar` does not stop immediately on error
* It creates a **partial archive**
* Exit status is the only reliable indicator of failure

### Key Learning

A backup file existing does not mean it is correct.

---

## 4. Experiment 2: Partial Backup Behavior

### Observation

```bash
tar -tf test_backup.tar
```

* The unreadable file was missing
* Other files were present

### Insight

This leads to **silent partial failure**:

* Backup appears valid
* Critical data is missing

### Key Learning

Partial backups are dangerous because they create **false confidence**.

---

## 5. Experiment 3: Pre-check Mechanism

### Approach

```bash
find project_data ! -readable
```

### Observation

* Unreadable files detected before backup
* Backup aborted intentionally

### Fix

```bash
chmod 600 secrets/secret.key
```

Re-run check:

```bash
find project_data ! -readable
```

* No output → safe to proceed

### Insight

Pre-validation ensures:

* No runtime surprises
* No partial backups

### Key Learning

Always validate conditions before performing critical operations.

---

## 6. Experiment 4: Hot File Problem

### Setup

Created a continuously updating file:

```bash
while true; do echo "log entry $(date +%T)" >> live.log; sleep 0.2; done
```

### Backup During Writes

```bash
tar -cvf hot_backup.tar project_data
```

### Observation

* Backup completed without errors
* Extracted file contained mixed data

### Insight

* File was modified during backup
* Backup contains inconsistent state

### Key Learning

Backup is not a snapshot. It is a **stream of reads over time**.

---

## 7. Understanding Consistency

### Definition

A consistent backup means:

All files represent the **same point in time**

### Reality

With `tar`:

* File A read at time t1
* File B read at time t2
* File C read at time t3

This creates **temporal inconsistency**.

### Key Learning

Even successful backups can be logically incorrect.

---

## 8. Strategies for Reliability

### 8.1 Excluding Hot Files

```bash
tar --exclude="*.log" -cvf backup.tar project_data
```

* Improves consistency
* Reduces risk of corruption
* Sacrifices completeness

---

### 8.2 Temporary Snapshot Copy

```bash
cp -r project_data temp_snapshot
tar -cvf backup.tar temp_snapshot
```

* Reduces exposure to changes
* More consistent than direct backup
* Uses more disk space and I/O

---

### 8.3 Timing Strategy

* Run backups during low activity
* Reduces probability of inconsistency

---

### 8.4 Change Detection

* Compare file metadata before and after
* Detect files modified during backup

---

## 9. Final Safe Backup Workflow

### Pre-check Phase

1. Validate directory existence
2. Detect unreadable files

```bash
find project_data ! -readable
```

3. Abort if any issues found

---

### Execution Phase

1. Create archive

```bash
tar -cvf project_backup.tar project_data
```

2. Check exit status

```bash
echo $?
```

* Must be 0

---

### Post-processing Phase

1. Verify archive contents

```bash
tar -tf project_backup.tar
```

2. Compress

```bash
gzip project_backup.tar
```

3. Add timestamp

```bash
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
mv project_backup.tar.gz project_backup_$TIMESTAMP.tar.gz
```

---

### Final Verification

```bash
tar -tzf project_backup_*.tar.gz
```

---

## 10. Failure Handling

If backup fails:

* Do not trust partial archive
* Delete incomplete backup
* Report error clearly

---

## 11. Key Learnings

1. Backup tools are best-effort, not safe by default
2. Exit status is critical for detecting failure
3. Partial backups are dangerous and misleading
4. Filesystem changes during backup cause inconsistency
5. Consistency, completeness, and performance are trade-offs
6. Pre-validation and post-verification are essential
7. A backup is only useful if it can be trusted

---

## 12. Final Conclusion

Backup is not just a command. It is a **system design problem** involving:

* correctness
* consistency
* validation
* failure handling

A reliable backup workflow must:

* detect errors early
* avoid unsafe conditions
* verify results
* ensure trustworthiness

This assignment transformed the understanding of backup from a simple command execution to a structured, reliable system process.

---
