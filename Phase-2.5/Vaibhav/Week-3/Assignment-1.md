# Assignment 1: File Descriptor Mastery

- Create commands that:
    - Redirect stdout only
    - Redirect stderr only
- Merge both
- Separate both
- Then intentionally generate errors and observe output.

---

## Assignment Breakdown

- C → Create commands producing output and errors
- T → Apply redirection
- F → Generate errors intentionally
- O → Observe outputs in files and terminal
- D → Compare stdout vs stderr handling
- X → Explain file descriptors

---

## Step-by-Step Execution

### C → Create commands producing output and errors

```bash
ls existing_file non_existing_file
```

---

### T → Redirect stdout only

```bash
ls existing_file non_existing_file > out.txt
```

---

### O → Observation

```bash
cat out.txt
```

Expected Output:

```bash
existing_file
```

Terminal Output:

```bash
ls: cannot access 'non_existing_file': No such file or directory
```

---

### T → Redirect stderr only

```bash
ls existing_file non_existing_file 2> err.txt
```

---

### O → Observation

```bash
cat err.txt
```

Expected Output:

```bash
ls: cannot access 'non_existing_file': No such file or directory
```

Terminal Output:

```bash
existing_file
```

---

### T → Merge stdout and stderr

```bash
ls existing_file non_existing_file > all.txt 2>&1
```

---

### O → Observation

```bash
cat all.txt
```

Expected Output:

```bash
existing_file
ls: cannot access 'non_existing_file': No such file or directory
```

---

### T → Separate both

```bash
ls existing_file non_existing_file > out.txt 2> err.txt
```

---

### O → Observation

```bash
cat out.txt
```

Expected Output:

```bash
existing_file
```

```bash
cat err.txt
```

Expected Output:

```bash
ls: cannot access 'non_existing_file': No such file or directory
```

---

## D → Differentiation

- stdout (fd 1) carries normal output
- stderr (fd 2) carries error messages
- They can be redirected independently or combined
- Default behavior sends both to terminal

---

## Explanation

### File Descriptors

Every process has standard file descriptors:
0 → stdin  
1 → stdout  
2 → stderr

stdout is used for normal program output, while stderr is used for error messages.

---

### Redirection Behavior

Using > redirects stdout, while 2> redirects stderr. The syntax 2>&1 merges stderr into stdout, allowing both outputs to
be handled together.

---

### Why This Matters

Separating stdout and stderr is useful for logging and debugging, while merging them helps when you want a complete
combined output stream for analysis or storage.