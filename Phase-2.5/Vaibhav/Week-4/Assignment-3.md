# Assignment 3: Data Extraction Challenge

## Original Assignment

- Given a CSV-like file:
    - Extract column 2
    - Filter rows
    - Compute aggregate
- Must use:
    - awk
    - cut
    - grep

---

## Building Blocks Breakdown

- E → Create CSV-like file
- P → Extract and process data
- T → Filter rows
- D → Differentiate filtered vs raw data
- O → Observe processed output
- X → Explain text processing

---

## Step-by-Step Execution

### E → Environment Setup (Create File)

```bash
cat << EOF > data.csv
id,name,marks
1,Alice,85
2,Bob,90
3,Charlie,78
4,Alice,92
EOF
```

---

### P → Extract Column 2 (Using cut)

```bash
cut -d',' -f2 data.csv
```

Expected Output:

```bash
name
Alice
Bob
Charlie
Alice
```

---

### T → Filter Rows (Using grep)

```bash
grep 'Alice' data.csv
```

Expected Output:

```bash
1,Alice,85
4,Alice,92
```

---

### P → Extract Column 2 After Filtering

```bash
grep 'Alice' data.csv | cut -d',' -f2
```

Expected Output:

```bash
Alice
Alice
```

---

### P → Compute Aggregate (Using awk)

```bash
awk -F',' 'NR>1 {sum+=$3} END {print sum}' data.csv
```

Expected Output:

```bash
345
```

---

## D → Differentiation

- cut extracts specific columns
- grep filters rows based on patterns
- awk performs computation and aggregation
- Combining tools enables flexible data processing

---

## Explanation

### Column Extraction

cut splits each line using a delimiter and extracts specific fields. It is efficient for simple column-based operations.

---

### Row Filtering

grep searches for patterns in text and filters matching lines. It is useful for narrowing down relevant data.

---

### Aggregation

awk is powerful for processing structured data. It can perform calculations like summing values across rows, making it
ideal for aggregation tasks.

---

### Combining Tools

Using grep, cut, and awk together allows building flexible pipelines that can filter, extract, and compute results
efficiently without writing full programs.