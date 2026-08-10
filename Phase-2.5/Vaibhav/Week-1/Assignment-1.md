# Assignment 1: Filesystem Forensics

Task:

- Create a directory structure like:

```
|--project/
   |----src/
   |--build/
   |----log/
```

- Create files inside src/
- Create:
    - One hard link
    - One symbolic link
- Delete the original file.
- Observe behavior using:
    - `ls -li`
    - `stat`

Deliverable:

- Explain inode behavior
- Explain why one link survives and one breaks

## Assignment Breakdown

- E → Create directory structure
- C → Create files
- T → Create hard link and symbolic link
- F → Delete original file
- O → Observe using `ls -li`, `stat` (before & after F)
- D → Compare inode behavior before and after deletion
- X → Explain inode behavior and link survival

---

## Step-by-Step Execution

### E → Create directory structure

```bash
mkdir -p project/src project/build/log
cd project/src
```

---

### C → Create files

```bash
echo 'sample data' > original.txt
```

---

### T → Create hard link and symbolic link

```bash
ln original.txt hard_link.txt
ln -s original.txt soft_link.txt
```

---

### O → Observation (Before Deletion)

```bash
ls -li
```

Expected Output:

```bash
12345 original.txt
12345 hard_link.txt
67890 soft_link.txt
```

---

```bash
stat original.txt hard_link.txt soft_link.txt
```

Expected Output:

```
Links: 2  (for original.txt and hard_link.txt)
Links: 1  (for soft_link.txt)
```

---

### F → Delete original file

```
rm original.txt
```

---

### O → Observation (After Deletion)

```
ls -li
```

Expected Output:

```
12345 hard_link.txt
67890 soft_link.txt -> original.txt (broken)
```

---

```
stat hard_link.txt soft_link.txt
```

Expected Output:

```
Links: 1  (hard_link.txt still valid)
soft_link.txt: No such file or broken link
```

---

### D → Differentiation

- Hard link still accessible and contains data
- Soft link exists but points to a non-existent file

---

## Explanation

### Inode Behavior

In Linux, a file is identified by its inode, not its name. The inode stores metadata like permissions, size, and disk
location. Filenames are simply references (links) to that inode. Multiple filenames can point to the same inode.

---

### Why Hard Link Survives

A hard link directly references the same inode as the original file. When the original file is deleted, the inode is not
removed because another reference (hard link) still exists. The file data remains accessible through the hard link.

---

### Why Symbolic Link Breaks

A symbolic link does not point to the inode. Instead, it stores the path to the original file. When the original file is
deleted, the path becomes invalid. As a result, the symbolic link points to a non-existent location and breaks.
