# Assignment 3: Heredoc Script Input

Write a small script that:
- Accepts heredoc input
- Processes lines
- Outputs structured results

---

## Assignment Breakdown

- C → Create script
- T → Accept heredoc input
- P → Process input lines
- O → Output structured results
- D → Differentiate raw vs processed data
- X → Explain heredoc and stdin behavior

---

## Step-by-Step Execution

### C → Entity Creation (Script)

```bash
cat << 'EOF' > process.sh
#!/bin/bash

count=0

while read line; do
count=$((count+1))
echo "Line $count: $line"
done
EOF

chmod +x process.sh
```

---

### T → Provide Heredoc Input

```bash
./process.sh << EOF
apple
banana
cherry
EOF
```

---

### O → Observation

Expected Output:
```bash
Line 1: apple
Line 2: banana
Line 3: cherry
```

---

## D → Differentiation

- Raw input is plain lines
- Processed output adds structure (line numbers)
- Script transforms stdin into formatted output

---

## Explanation

### Heredoc Input

A heredoc allows you to pass multiple lines of input directly into a command or script using standard input. The shell
sends everything between the markers (EOF) to the program.

---

### Processing Lines

The script reads input line by line using a while read loop. Each line is processed sequentially, allowing
transformations like numbering, filtering, or formatting.

---

### Structured Output

Instead of printing raw input, the script formats each line with additional context. This demonstrates how stdin can be
programmatically transformed into meaningful output.