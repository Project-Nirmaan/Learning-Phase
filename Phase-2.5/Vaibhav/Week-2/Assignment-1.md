# Assignment 1: Process Investigation

- Start multiple background processes:
    - `sleep`
    - `yes > /dev/null`
- Use:
    - `ps`
    - `top`
    - `pstree`
    - `lsof`
- Explain:
    - Process hierarchy
    - CPU consumption
    - Open file descriptors

---

## Assignment Breakdown

- C → Start processes
- O → Observe using `ps`, `top`, `pstree`, `lsof`
- D → Compare behavior across processes
- X → Explain process concepts

---

## Step-by-Step Execution

### C → Start processes

```bash
sleep 1000 &
yes > /dev/null &
```

---

### O → Observation (`ps`)

```bash
ps aux | grep -E 'sleep|yes'
```

Expected Output:

```bash
user 1234 0.0 sleep 1000
user 1235 99.0 yes
```

---

### O → Observation (`top`)

```bash
top
```

Expected Output:

```bash
PID COMMAND %CPU
1234 sleep  0.0
1235 yes    ~100
```

---

### O → Observation (`pstree`)

```bash
pstree -p
```

Expected Output:

```bash
bash(1200)─┬─sleep(1234)
           └─yes(1235)
```

---

### O → Observation (`lsof`)

```bash
lsof -p <PID_of_yes>
```

Expected Output:

```bash
yes 1235 user 1w /dev/null
yes 1235 user 2w /dev/null
```

---

## D → Differentiation

- `sleep` consumes almost no CPU
- `yes` consumes maximum CPU
- both are child processes of the shell
- `yes` redirects output to /dev/null

---

## Explanation

### Process Hierarchy

Each process in Linux has a parent process. When you start a command in the terminal, it becomes a child of the shell
process. Tools like `pstree` show this relationship clearly, where both sleep and yes appear under the shell that launched
them.

---

### CPU Consumption

The sleep command is idle and simply waits for a specified time, so it uses negligible CPU. The `yes` command continuously
generates output in an infinite loop, which keeps the CPU busy and results in very high CPU usage.

---

### Open File Descriptors

Every process uses file descriptors to interact with files and streams. By default:

- 0 → stdin
- 1 → stdout
- 2 → stderr

In the case of `yes` > /dev/null, both stdout and stderr are redirected to /dev/null, which is why lsof shows those
descriptors pointing there. This means the output is discarded instead of being displayed.