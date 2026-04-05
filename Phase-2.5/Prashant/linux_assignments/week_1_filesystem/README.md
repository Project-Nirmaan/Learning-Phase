# Week 1 - Filesystem Basics (Inodes, Links, Permissions)

## Why This Matters
In Linux, files are not just names. The real identity of a file is its inode, and names are just labels pointing to that inode.

Simple thinking:
- Hard Link: "Ek hi bande ke do naam (Nicknames)".
- Soft Link: "Ghar ka address ek parchi pe likhna (Shortcut)."

If you understand this, you avoid common production mistakes like deleting the wrong path, misunderstanding storage usage, or breaking scripts after moving files.

## Core Concepts
- Inode: Stores metadata (owner, size, permissions, timestamps, disk blocks).
- Hard Link: Another filename pointing to the same inode.
- Soft Link (Symlink): A separate file that stores a path to another file.
- Permissions: Control who can read (`r`), write (`w`), and execute (`x`).

## Analogy (Hinglish)
- Hard link is like one person having two names in different friend groups.
  Both names point to the same real person.
- Soft link is like writing someone's home address on a slip.
  If the person shifts home, that old address slip becomes useless.

## Run the Demo
```bash
chmod +x inode_link_demo.sh
./inode_link_demo.sh
```

## What to Observe
- `original.txt` and `hard_link.txt` have the same inode number.
- `soft_link.txt` has a different inode because it stores only a path.
- Permission changes on `original.txt` affect `hard_link.txt` (same inode).
- If target file moves/deletes, symlink can break.
