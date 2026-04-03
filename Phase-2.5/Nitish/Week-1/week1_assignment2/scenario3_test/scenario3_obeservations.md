# Scenario 3: Operation-Based Permission Enforcement

## 1. Objective

To demonstrate that file permissions are enforced based on the specific operation being performed (read, write, execute), not just on file ownership or general access.

---

## 2. Setup

Created working directory:

```
scenario3_test/
```

---

## 3. Case A: Write Allowed, Read Denied

### Setup

```
echo "Hidden Data" > file_A.txt
chmod 200 file_A.txt
```

Permissions:

```
-w-------
```

---

### Observations

#### Read Attempt

```
cat file_A.txt
```

Output:

```
Permission denied
```

---

#### Write Attempt

```
echo "New Data" >> file_A.txt
```

Result:

* Operation succeeds

---

### Explanation

* `cat` requires read permission
* `echo >>` requires write permission

Owner has:

* write ✔
* read ❌

---

## 4. Case B: Read Allowed, Write Denied

### Setup

```
echo "Read only Data" > file_B.txt
chmod 400 file_B.txt
```

Permissions:

```
r--------
```

---

### Observations

#### Read Attempt

```
cat file_B.txt
```

Output:

```
Read only Data
```

---

#### Write Attempt

```
echo "trying to write" >> file_B.txt
```

Output:

```
Permission denied
```

---

### Explanation

* Read operation succeeds due to `r`
* Write operation fails due to missing `w`

---

## 5. Case C: Execute vs Interpret

### Setup

```
echo 'echo "running Script"' > script.sh
chmod 644 script.sh
```

Permissions:

```
rw-r--r--
```

---

### Observations

#### Direct Execution

```
./script.sh
```

Output:

```
Permission denied
```

---

#### Interpreter Execution

```
bash script.sh
```

Output:

```
running Script
```

---

### Explanation

* `./script.sh` uses `execve()` → requires execute permission
* `bash script.sh` reads file → requires read permission

---

## 6. Case D: No Permissions

### Setup

```
echo "Nothing allowed" > file_C.txt
chmod 000 file_C.txt
```

Permissions:

```
----------
```

---

### Observations

#### Read Attempt

```
cat file_C.txt
```

Output:

```
Permission denied
```

---

#### Write Attempt

```
echo "Write Test" >> file_C.txt
```

Output:

```
Permission denied
```

---

## 7. Core Explanation

File permissions are evaluated based on the operation requested:

* read → requires `r`
* write → requires `w`
* execute → requires `x`

The kernel checks permissions **per operation**, not per file.

---

## 8. Key Insight

Being the owner of a file does not guarantee full access.

Each operation is validated independently:

* A file may be writable but not readable
* A file may be readable but not executable
* Execution and interpretation are different operations

---

## 9. Conclusion

Permission enforcement in Linux is operation-specific.

The kernel evaluates:

1. Identity (owner/group/others)
2. Applicable permission bits
3. Required permission for the syscall

Access is granted only if all conditions are satisfied.

---

---
# Linux Permission Model -> Unified Understanding

## 1. Permission Evaluation Pipeline

Every file operation in Linux follows a fixed sequence:

```
Path Resolution → Identity Selection → Operation Check → Permission Validation
```

---

## 2. Step 1: Path Resolution (Directory Level)

Before accessing a file, the kernel resolves its path.

Requirement:

* Execute (x) permission on every directory in the path

Failure here results in:

* Permission denied before file is even considered

---

## 3. Step 2: Identity Selection

The kernel determines which permission set applies:

```
if (user == owner) → use owner bits
else if (user ∈ group) → use group bits
else → use others bits
```

Important:

* Only one category is used
* Other permissions are ignored

---

## 4. Step 3: Operation Mapping

Each command maps to a syscall and required permission:

| Operation | Syscall                  | Required Permission |
| --------- | ------------------------ | ------------------- |
| Read      | read() / open(O_RDONLY)  | r                   |
| Write     | write() / open(O_WRONLY) | w                   |
| Execute   | execve()                 | x                   |

---

## 5. Step 4: Permission Validation

Kernel checks:

```
Does selected permission set contain required bit?
```

If not:

```
→ -EACCES (Permission denied)
```

---

## 6. Redirection Internals

Example:

```
echo "data" > file
```

Execution flow:

```
open(file, O_WRONLY | O_CREAT | O_TRUNC)
dup2(fd, STDOUT)
execve(echo)
write()
close()
```

Important:

* Permission is checked during `open()`
* Echo does not write to file directly

---

## 7. Key Insights

* Permissions are operation-specific, not general access
* Being owner does not guarantee full access
* Directory execute permission controls traversal
* Ownership determines which permission set applies
* Redirection is handled by the shell, not the command

---

## 8. Common Misconceptions

1. "If I have some permission, I can access the file"
   → False, must match operation

2. "Group permissions can override owner"
   → False, only one category applies

3. "Read permission allows entering directories"
   → False, execute is required

---

## 9. Unified Final Flow

```
resolve_path()
check_directory_execute()

inode = lookup()

mode = select(owner/group/others)

if (!has_permission(mode, operation))
    return -EACCES
```

---

## 10. Practical Mapping to Scenarios

| Scenario   | Failure Point        |
| ---------- | -------------------- |
| Scenario 1 | Path traversal       |
| Scenario 2 | Identity selection   |
| Scenario 3 | Operation permission |

---
