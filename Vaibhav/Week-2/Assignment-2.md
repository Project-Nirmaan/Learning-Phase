# Assignment 2: Signal Lab

- Start a long-running process.
- Send:
  - `SIGINT`
  - `SIGTSTP`
  - `SIGCONT`
  - `SIGKILL`
- Document behavioral differences.

---

## Assignment Breakdown

- C → Start long-running process
- T → Send signals
- O → Observe process state
- D → Compare behavior across signals
- X → Explain signal behavior

---

## Step-by-Step Execution

### C → Start long-running process

```bash
sleep 1000
```

---

### T → Send SIGINT (Ctrl + C)

```bash
Ctrl + C
```

---

### O → Observation

Expected Output:

```bash
Process terminated
```

---

### C → Restart Process

```bash
sleep 1000
```

---

### T → Send SIGTSTP (Ctrl + Z)

```bash
Ctrl + Z
```

---

### O → Observation

Expected Output:

```bash
[1]+ Stopped sleep 1000
```

---

### T → Send SIGCONT

```bash
bg
```

---

### O → Observation

Expected Output:

```bash
[1]+ sleep 1000 &
```

---

### T → Send SIGKILL

```bash
kill -9 %1
```

---

### O → Observation

Expected Output:

```bash
[1]+ Killed sleep 1000
```

---

## D → Differentiation

- `SIGINT` → Terminates process gracefully
- `SIGTSTP` → Suspends process (stops execution)
- `SIGCONT` → Resumes suspended process
- `SIGKILL` → Forcefully kills process (cannot be handled)

---

## Explanation

### `SIGINT`

`SIGINT` is sent when pressing Ctrl + C. It interrupts the process and requests termination. Most processes handle it
gracefully and exit cleanly.

---

### `SIGTSTP`

`SIGTSTP` is sent using Ctrl + Z. It pauses the process and moves it to the background in a stopped state without
terminating it.

---

### `SIGCONT`

`SIGCONT` resumes a stopped process. It allows a previously suspended process to continue execution either in foreground
or background.

---

### `SIGKILL`

`SIGKILL` forcefully terminates a process. It cannot be caught or ignored by the process, making it the most aggressive
way to stop execution.