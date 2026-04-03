# Scenario 1: Missing Execute Permission on Directory

## 1. Objective

To demonstrate that lack of execute permission on a directory prevents access to files inside it, even if the file itself has valid permissions.

---

## 2. Setup

Created directory structure:

```
scenario1_test/
└── secure_dir/
    └── secret.txt
```

Created file:

```
echo "This is a protected file" > secure_dir/secret.txt
```

---

## 3. Initial Verification

Accessing file before permission change:

```
cat secure_dir/secret.txt
```

Output:

```
This is a protected file
```

This confirms:

* File is readable
* Directory traversal is allowed

---

## 4. Removing Execute Permission

Changed directory permissions:

```
chmod 644 secure_dir
```

Directory state:

```
ls -ld secure_dir
drw-r--r--
```

---

## 5. Observations After Permission Change

### 5.1 File Access

```
cat secure_dir/secret.txt
```

Output:

```
Permission denied
```

---

### 5.2 Directory Listing

```
ls secure_dir
```

Output:

```
secret.txt
ls: cannot access 'secure_dir/secret.txt': Permission denied
```

Observation:

* Filename is visible
* Metadata access is restricted

---

### 5.3 Directory Traversal

```
cd secure_dir
```

Output:

```
Permission denied
```

---

### 5.4 Direct Metadata Access

```
ls -l secure_dir/secret.txt
```

Output:

```
Permission denied
```

---

## 6. Additional Experiments

Tried modifying permissions without adding execute:

```
chmod 655 secure_dir
chmod 666 secure_dir
```

Result:

* File still inaccessible
* All operations continue to fail

Only after restoring execute:

```
chmod 777 secure_dir
```

Access was restored.

---

## 7. Core Explanation

Directory permissions behave differently from file permissions.

For directories:

* Read (r) → allows listing filenames
* Write (w) → allows creating/deleting files
* Execute (x) → allows traversal (entering directory and accessing contents)

---

## 8. Root Cause

The failure occurs because:

* Directory lacks execute permission
* Kernel cannot traverse the path
* File permission is never evaluated

---

## 9. Key Insight

Even though:

* File has valid read permissions
* Directory has read permission

Access still fails because execute permission is required for traversal.

---

## 10. Real System Impact

This behavior affects:

* File access (`cat`, `nano`)
* Directory navigation (`cd`)
* Metadata inspection (`ls -l`)
* Version control tools (`git add`)

Example observed:

```
fatal: unable to stat '.../secret.txt': Permission denied
```

---

## 11. Conclusion

Directory execute permission is mandatory for accessing any file inside it.

Without execute permission:

* Paths cannot be resolved
* Files cannot be accessed
* System calls fail at the directory level

This demonstrates that:

"File accessibility depends on both directory traversal and file permissions, not just file permissions alone."
