# Assignment 2: Permission Debugging Drill

You are given:
`Permission denied`

Simulate 3 different causes:
- Missing execute on directory
- Wrong ownership
- Incorrect file mode

Then fix them without using sudo unless necessary.

## Assignment Breakdown

- E → Create directory and file setup
- C → Create test file
- F → Introduce permission errors (3 cases)
- O → Observe using `ls -l`, access attempts
- V → Fix issues
- D → Compare failure reasons
- X → Explain causes of permission denied

---

## Step-by-Step Execution

### E → Environment Setup

```bash
mkdir -p perm_test/dir1
cd perm_test/dir1
```

---

### C → Entity Creation

```bash
echo 'test data' > file.txt
```

---

## Case 1: Missing Execute Permission on Directory

### F → Remove Execute Permission

```bash
chmod 666 .
```

---

### O → Observation

```bash
ls -l
```

Expected Output:

```bash
drw-rw-rw- dir1
```

```bash
cat file.txt
```

Expected Output:

```bash
Permission denied
```

---

### V → Fix

```bash
chmod +x .
```

---

## Case 2: Wrong Ownership

### F → Change Ownership (simulate mismatch)

```bash
sudo chown root:root file.txt
```

---

### O → Observation

```bash
ls -l file.txt
```

Expected Output:

```bash
-rw-r--r-- 1 root root file.txt
```

```bash
echo 'data' >> file.txt
```

Expected Output:

```bash
Permission denied
```

---

### V → Fix

```bash
sudo chown $USER:$USER file.txt
```

---

## Case 3: Incorrect File Mode

### F → Remove Read/Write Permissions

```bash
chmod 000 file.txt
```

---

### O → Observation

```bash
cat file.txt
```

Expected Output:

```bash
Permission denied
```

---

### V → Fix

```bash
chmod 644 file.txt
```

---

## D → Differentiation

- Directory without execute → cannot access contents
- Wrong ownership → user lacks permission despite correct mode
- File mode restrictive → no read/write allowed

---

## Explanation

### Missing Execute on Directory

Directories require execute (x) permission to access files inside them. Without it, even if the file itself has
permissions, access is denied.

---

### Wrong Ownership

If a file is owned by another user, permissions are evaluated based on owner/group/others. If the current user is not
the owner and lacks sufficient permissions, access is denied.

---

### Incorrect File Mode

File mode defines read, write, and execute permissions. If all permissions are removed (000), no user can read or
modify the file, resulting in permission denied.
