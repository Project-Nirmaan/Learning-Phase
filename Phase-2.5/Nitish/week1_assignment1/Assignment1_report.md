# Week-1 Assignment 1: Filesystem Forensics

## 1. Objective

Understand how the Linux filesystem behaves with respect to:

* Inodes
* Hard links
* Symbolic links
* File deletion (unlink semantics)

---

## 2. Directory Structure

```
project/
├── src/
│   ├── file1.txt
│   ├── file2.txt (hard link)
│   └── file3.txt (symbolic link)
├── build/
└── log/
```

---

## 3. Steps Performed

1. Created a file:

   ```
   echo "Hello I am the main file" > file1.txt
   ```

2. Created a hard link:

   ```
   ln file1.txt file2.txt
   ```

3. Created a symbolic link:

   ```
   ln -s file1.txt file3.txt
   ```

4. Deleted the original file:

   ```
   rm file1.txt
   ```

---

## 4. Observations

After deleting `file1.txt`:

* `file2.txt` remains accessible and contains data
* `file3.txt` results in "No such file or directory"

Using:

```
ls -li
stat <filename>
```

* `file2.txt` shares the same inode as the original file
* `file3.txt` has a different inode and stores a path reference

---

## 5. Inode Behavior

An inode is the actual representation of a file inside the filesystem. It stores:

* File metadata (permissions, timestamps, size)
* Pointers to data blocks

Important point:

A filename is not part of the inode.
Directories map filenames to inode numbers.

---

## 6. Hard Link Analysis

A hard link is another directory entry pointing to the same inode.

Before deletion:

```
file1.txt ──┐
            ├──> inode X → data
file2.txt ──┘
```

After deletion:

```
file2.txt ──> inode X → data
```

Reason it survives:

* The inode still has a reference from `file2.txt`
* The kernel removes data only when link count becomes zero

Conclusion:

Data is associated with the inode, not with the filename.

---

## 7. Symbolic Link Analysis

A symbolic link is a file that stores the path to another file.

Before deletion:

```
file3.txt → "file1.txt"
```

After deletion:

```
file3.txt → "file1.txt" (target missing)
```

Reason it breaks:

* It does not reference the inode
* It only stores the filename/path
* Path resolution fails after the original file is removed

Conclusion:

Symbolic links depend on the existence of the target path.

---

## 8. Comparison

| Feature           | Hard Link | Symbolic Link   |
| ----------------- | --------- | --------------- |
| Reference type    | Inode     | Path (filename) |
| Survives deletion | Yes       | No              |
| Same inode        | Yes       | No              |
| Cross filesystem  | No        | Yes             |

---

## 9. Core Insight

The Linux filesystem is inode-based, not filename-based.

Deleting a file removes only the directory entry.
The data remains as long as at least one reference to the inode exists.

Hard links operate at the inode level.
Symbolic links operate at the path level.

---

## 10. Learning Outcome

* Understood unlink semantics
* Understood inode vs filename distinction
* Understood why hard links persist and symbolic links break

---

## 11. Reflection

This experiment shows that what users call a "file" is actually:

* An inode (data + metadata)
* One or more directory entries pointing to it

Filenames are simply references, not the data itself.
