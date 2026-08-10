# Assignment 2: Pipeline Engineering

Given a messy log file, extract:
- Unique error messages
- Count occurrences
- Sort by frequency

---

## Assignment Breakdown

- E → Create messy log file
- P → Process data using pipeline
- D → Differentiate counts and frequencies
- X → Explain pipeline behavior

---

## Step-by-Step Execution

### E → Create messy log file

```bash
cat << EOF > log.txt
ERROR Disk full
INFO Service started
ERROR Disk full
WARNING Memory low
ERROR Network down
ERROR Disk full
WARNING Memory low
EOF
```
---

### P → Extract Error Messages

```bash
grep 'ERROR' log.txt
```
Expected Output:
```bash
ERROR Disk full
ERROR Disk full
ERROR Network down
ERROR Disk full
```
---

### P → Extract Unique Errors

```bash
grep 'ERROR' log.txt | sort | uniq
```
Expected Output:
```bash
ERROR Disk full
ERROR Network down
```
---

### P → Count Occurrences

```bash
grep 'ERROR' log.txt | sort | uniq -c
```
Expected Output:
```bash
3 ERROR Disk full
1 ERROR Network down
```
---

### P → Sort by Frequency

```bash
grep 'ERROR' log.txt | sort | uniq -c | sort -nr
```
Expected Output:
```bash
3 ERROR Disk full
1 ERROR Network down
```
---

## D → Differentiation

- Raw logs contain mixed entries
- Filtering isolates only errors
- uniq identifies distinct messages
- uniq -c counts occurrences
- sort -nr orders by highest frequency

---

## Explanation

### Pipeline Concept

A pipeline connects multiple commands using the pipe operator |, where the output of one command becomes the input of
the next. This allows step-by-step data transformation without creating intermediate files.

---

### Why This Works

grep filters relevant lines, sort groups identical lines together, uniq identifies and counts duplicates, and sort -nr
arranges results by frequency. Each tool performs a small task, and together they form a powerful data processing chain.

---

### Practical Use

This pattern is commonly used in log analysis to quickly identify the most frequent issues in a system, helping
prioritize debugging and monitoring efforts.