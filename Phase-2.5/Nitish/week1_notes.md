# 📂 Week-1 — Filesystem Semantics & File Manipulation
---

# 🧠 Topic-1: Filesystem Navigation

---

## 1. Problem Statement

Computers operate on:

* Disk blocks
* Memory addresses
* Raw bytes

Humans operate on:

* Names
* Paths
* Hierarchies

👉 A **filesystem** bridges this gap by mapping:

```
Human-readable path → Kernel-managed object (inode)
```

---

## 2. Core Concept

### 🔑 Key Principle

```
File ≠ Filename
```

| Component   | Meaning              |
| ----------- | -------------------- |
| Filename    | Human-readable label |
| Inode       | Actual file identity |
| Data blocks | File content         |

👉 A directory stores:

```
(name → inode mapping)
```

---

## 3. Filesystem Structure

### Hierarchical Model

```
/
├── home
│   └── user
│       └── file.txt
```

### Internal Representation

```
Directory → list of (name → inode)
inode → metadata + data block pointers
```

---

## 4. Path Resolution (Critical Mechanism)

When accessing:

```
/home/user/file.txt
```

### Kernel Process:

1. Start at root `/`
2. Lookup "home"
3. Fetch inode
4. Lookup "user"
5. Continue until target

👉 Called **path traversal**

---

### Important Properties

* Each `/` = lookup step
* Permission checked at every level
* Uses caching (dentry cache)

---

## 5. Abstraction Layer — VFS

### Problem:

Different filesystems:

* ext4
* xfs
* ntfs

### Solution:

**Virtual File System (VFS)**

```
User → syscall → VFS → actual filesystem
```

### Purpose:

* Uniform interface
* Hardware abstraction
* Modular design

---

## 6. Key Commands & Their Meaning

---

### 🔹 pwd

```
pwd
```

* Shows current working directory (CWD)
* Kernel stores CWD in process structure

---

### 🔹 cd

```
cd /home/user
```

* Changes current directory
* Uses `chdir()` syscall
* Affects only current process

---

### 🔹 ls

```
ls
ls -l
ls -a
ls -R
```

* Lists directory entries
* Does NOT read file contents
* Uses directory read syscalls

---

### 🔹 tree

```
tree
```

* Recursive directory traversal

---

## 7. Important Concepts

---

### Absolute vs Relative Path

| Type     | Example         | Meaning                |
| -------- | --------------- | ---------------------- |
| Absolute | `/home/user`    | From root              |
| Relative | `docs/file.txt` | From current directory |

---

### Hidden Files

```
ls -a
```

* Files starting with `.`
* Convention-based hiding

---

### "." and ".."

```
.   → current directory  
..  → parent directory
```

👉 These are actual directory entries

---

### Directory Hierarchy

* Enables scalability
* Organizes namespace
* Provides isolation

---

## 8. Design Decisions (Why This Works)

| Design Choice      | Reason             |
| ------------------ | ------------------ |
| Hierarchy          | Scalable structure |
| Inode separation   | Flexibility        |
| Incremental lookup | Memory efficient   |
| VFS layer          | Portability        |

---

## 9. Limitations & Improvement Ideas

| Problem             | Possible Improvement |
| ------------------- | -------------------- |
| Slow deep traversal | Path caching         |
| String comparisons  | Hash-based lookup    |
| No semantics        | Tag-based FS         |
| Repeated lookups    | Better indexing      |

---

# 🧠 Topic-2: Creating, Copying, Moving & Deleting

---

## 1. Problem Statement

We need to:

* Create files
* Duplicate data
* Move files
* Delete safely

---

## 2. Core Principle

```
File operations = manipulation of:
(name ↔ inode) + data blocks + reference counts
```

---

## 3. File Creation

### Command

```
touch file.txt
```

### Kernel Actions:

1. Allocate inode
2. Add directory entry:

```
file.txt → inode
```

3. No data blocks yet (empty file)

---

## 4. File Copy

### Command

```
cp file1 file2
```

### Behavior:

* New inode created
* Data blocks duplicated

👉 Result:

* Independent files

---

## 5. File Move

### Command

```
mv file1 file2
```

---

### Case 1: Same Filesystem

* Only rename occurs
* No data movement

```
old_name → inode
new_name → same inode
```

---

### Case 2: Different Filesystem

* Copy + delete

---

## 6. File Deletion (CRITICAL)

### Command

```
rm file.txt
```

---

### What Actually Happens:

1. Remove directory entry
2. Decrease inode link count
3. If:

```
link_count == 0 AND no open file descriptor
```

→ free inode + data blocks

---

### 🔥 Important Truth

```
Deleting a file removes the name, not necessarily the data immediately
```

---

## 7. Core Abstraction

| Layer        | Role                 |
| ------------ | -------------------- |
| User command | High-level operation |
| Syscall      | Kernel entry         |
| Inode        | Object identity      |
| Data blocks  | Actual storage       |

---

## 8. Commands Overview

---

### mkdir

```
mkdir dir
mkdir -p a/b/c
```

* Creates directory inode
* Adds `.` and `..`

---

### touch

```
touch file.txt
```

* Creates file or updates timestamp

---

### cp

```
cp file1 file2
cp -r dir1 dir2
```

---

### mv

```
mv file1 file2
```

---

### rm

```
rm file.txt
rm -r dir
rm -f file
```

---

## 9. Reference Counting (Very Important)

Each inode has:

```
link_count
```

### File is deleted only when:

```
link_count == 0 AND no process is using it
```

---

## 10. Practical Observations

---

### Copy creates new inode

```
cp file1 file2
ls -i
```

---

### Move keeps same inode

```
mv file1 file3
ls -i
```

---

### Hard link increases link count

```
ln fileA fileB
ls -l
```

---

### File survives deletion if open

```
nano file
rm file
```

👉 File still exists in memory

---

## 11. Design Decisions

| Design Choice         | Reason         |
| --------------------- | -------------- |
| Name/inode separation | Flexibility    |
| Reference counting    | Safe deletion  |
| Lazy deletion         | Process safety |
| Atomic rename         | Consistency    |

---

## 12. Limitations & Improvements

| Problem             | PossibleImprovement      |
| ------------------- | ------------------------ |
| Accidental deletion | Trash system             |
| Copy overhead       | Copy-on-write FS         |
| No versioning       | Snapshot FS              |
| No integrity check  | Checksums                |

---

# 🚀 Summary

| Topic      | Key Insight                |
| ---------- | -------------------------- |
| Navigation | Path → inode resolution    |
| Creation   | New inode + mapping        |
| Copy       | Duplicate data             |
| Move       | Rename (same FS)           |
| Delete     | Remove reference, not data |

---