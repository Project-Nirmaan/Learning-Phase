# Assignment 3: Safe Backup Workflow

Create a script-less manual workflow that:

- Archives a directory
- Compresses it
- Stores it with timestamp
- Verifies size before and after

## Building Blocks Breakdown

- E → Create directory with data
- C → Populate directory
- T → Archive and compress
- O → Observe size `du`, `ls -lh`
- D → Compare size before and after
- V → Verify archive integrity
- X → Explain workflow

---

## Step-by-Step Execution

### E → Environment Setup

```bash
mkdir -p backup_test/data
cd backup_test
```

---

### C → Entity Creation

```bash
echo 'file one' > data/file1.txt
echo 'file two' > data/file2.txt
```

---

### O → Observation (Original Size)

```bash
du -sh data
```

Expected Output:

```bash
4.0K data
```

---

### T → Archive Directory

```bash
tar -cf backup.tar data
```

---

### T → Compress Archive

```bash
gzip backup.tar
```

---

### O → Observation (Compressed Size)

```bash
ls -lh backup.tar.gz
```

Expected Output:

```bash
`-rw-r--r-- 1 user user 200B backup.tar.gz
```

---

### T → Store with Timestamp

```bash
mv backup.tar.gz backup_$(date +%Y%m%d_%H%M%S).tar.gz
```

---

### D → Differentiation

- Original directory size vs compressed archive size
- Compression reduces storage usage

---

### V → Verification

```bash
tar -tzf backup_*.tar.gz
```

Expected Output:

```
data/
data/file1.txt
data/file2.txt
```

---

## Explanation

### Archiving

Archiving combines multiple files and directories into a single file without reducing size. It preserves structure and
metadata.

---

### Compression

Compression reduces file size by eliminating redundancy in data. This helps in saving storage and improving transfer
efficiency.

---

### Timestamping

Adding a timestamp ensures that backups are uniquely identifiable and prevents overwriting previous backups.

---

### Size Verification

Comparing sizes before and after compression confirms that the backup process is effective and storage-efficient.

---

### Integrity Verification

Listing contents of the archive ensures that all files are correctly stored and can be restored when needed.
