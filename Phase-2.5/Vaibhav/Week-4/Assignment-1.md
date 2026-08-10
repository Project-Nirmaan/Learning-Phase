# Assignment 1: Log Analyzer

Given /var/log/syslog or any large log, extract:

- Errors from last hour
- Count per service
- Top 5 frequent issues
- Must combine tools.

---

## Assignment Breakdown

- E → Use system log file
- P → Extract logs based on conditions
- D → Differentiate frequency of issues
- X → Explain log analysis approach

---

## Step-by-Step Execution

### E → Use system log file

```bash
LOG_FILE=/var/log/syslog
```

---

### P → Extract Logs from Last Hour

```bash
date --date='1 hour ago' '+%b %d %H'
```

Example Output:

```bash
Apr 11 14
```

```bash
grep "$(date --date='1 hour ago' '+%b %d %H')" $LOG_FILE
```

---

### P → Extract Error Messages

```bash
grep "$(date --date='1 hour ago' '+%b %d %H')" $LOG_FILE | grep -i error
```

---

### P → Count Per Service

```bash
grep "$(date --date='1 hour ago' '+%b %d %H')" $LOG_FILE | grep -i error | awk '{print $5}' | sort | uniq -c
```

Expected Output:

```bash
5 sshd:
3 systemd:
2 kernel:
```

---

### P → Top 5 Frequent Issues

```bash
grep "$(date --date='1 hour ago' '+%b %d %H')" $LOG_FILE | grep -i error | sort | uniq -c | sort -nr | head -5
```

Expected Output:

```bash
10 ERROR Disk failure
7 ERROR Network timeout
5 ERROR Authentication failed
...
```

---

## D → Differentiation

- Raw logs contain mixed entries across time and services
- Time filtering isolates recent activity
- Service-based grouping highlights responsible components
- Frequency sorting identifies most critical issues

---

## Explanation

### Time-Based Filtering

System logs include timestamps, allowing filtering based on time ranges. By matching the last hour’s timestamp pattern,
only recent entries are selected.

---

### Service Identification

Logs typically include a service or process name. Extracting this field helps group errors by the component responsible,
which is useful for debugging.

---

### Frequency Analysis

Counting and sorting errors helps identify recurring issues. This makes it easier to prioritize problems based on how
often they occur.

---

### Combining Tools

This workflow demonstrates the power of combining small tools like grep, awk, sort, and uniq to perform complex log
analysis without writing full programs.