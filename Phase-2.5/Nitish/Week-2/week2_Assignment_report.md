# Week-2 Assignment Report

### Topic: Processes, Signals, and System Control

---

# 1. Objective

The goal of this assignment was to develop a **first-principles understanding of process behavior in a Linux system**, focusing on:

* Process lifecycle and scheduling
* CPU utilization behavior
* Signal-based control mechanisms
* Shell job control vs kernel process control
* Command resolution via PATH
* File lifecycle via inode and file descriptors
* System call interface between user space and kernel

---

# 2. Experimental Setup

Two terminals were used:

* **Terminal-1 (Controller)** → Process creation and control
* **Terminal-2 (Observer)** → Monitoring and analysis

---

# 3. Process Creation & CPU Behavior

## 3.1 Experiment

```bash
sleep 300 &
yes > /dev/null &
```

## 3.2 Observations

From `ps`:

* `sleep` → State: `S` (Sleeping), CPU: ~0%
* `yes` → State: `R` (Running), CPU: ~98–100%

From `top`:

* `yes` continuously occupied CPU
* Majority of processes were in `S` (sleeping) state

## 3.3 Analysis

```text
sleep → enters kernel → blocks on timer → removed from runqueue  
yes   → infinite loop → always runnable → scheduled continuously
```

### Key Insight

```
CPU does not execute "processes"
CPU executes instructions
Kernel decides WHICH process runs
```

### Conclusion

* **Execution ≠ CPU usage**
* Most processes are **waiting**, not running

---

# 4. Process Lifecycle & Termination

## 4.1 Graceful Termination

```bash
kill 1473
```

### Observation

* Process terminated normally
* Shell reported:

  ```
  Done sleep 300
  ```

## 4.2 Forceful Termination

```bash
kill -9 2124
```

### Observation

* Immediate termination
* Output:

  ```
  Killed sleep 300
  ```

## 4.3 Analysis

| Signal  | Behavior                         |
| ------- | -------------------------------- |
| SIGTERM | Graceful request                 |
| SIGKILL | Immediate, cannot be intercepted |

### Key Insight

```
kill ≠ kill
kill = signal delivery mechanism
```

```
SIGKILL bypasses user-space completely → enforced by kernel
```

---

# 5. Terminal Signals

## 5.1 Experiment

```bash
sleep 300
Ctrl + C
Ctrl + Z
```

## 5.2 Observations

* `Ctrl + C` → Process terminated
* `Ctrl + Z` → Process stopped

```bash
jobs
```

Output:

```
[3]+ Stopped sleep 300
```

## 5.3 Analysis

| Key      | Signal  |
| -------- | ------- |
| Ctrl + C | SIGINT  |
| Ctrl + Z | SIGTSTP |

### Key Insight

```
Keyboard → terminal driver → kernel → signal → process
```

---

# 6. Job Control vs Process Control

## 6.1 Experiment

```bash
sleep 200 &
jobs
fg %4
Ctrl + Z
bg %4
disown %4
```

## 6.2 Observations

* Jobs visible via `jobs`
* Foreground/background transitions worked
* `disown` removed job from shell tracking

## 6.3 Analysis

| Concept | Controlled By |
| ------- | ------------- |
| Job     | Shell         |
| Process | Kernel        |

### Key Insight

```
Shell manages jobs
Kernel manages processes
```

---

# 7. Command Resolution & PATH

## 7.1 Experiment

```bash
which ls
type cd
whereis bash
echo $PATH
```

## 7.2 Observations

* `ls` → `/usr/bin/ls` (external binary)
* `cd` → shell builtin
* PATH contained multiple directories

## 7.3 Analysis

```
Shell resolves command → searches PATH → executes via execve()
```

### Key Insight

```
Kernel does NOT know command names
Kernel executes binaries given by absolute path
```

---

# 8. File Lifecycle & Inode Behavior

## 8.1 Experiment

* Created file using `nano`
* Attempted deletion and inspection via `lsof`

## 8.2 Observations

* File not found after deletion
* No active file descriptor detected

## 8.3 Expected Behavior (Conceptual)

```
rm → removes directory entry (name → inode mapping)
File persists IF:
    link_count > 0 OR open file descriptor exists
```

### Key Insight

```
File ≠ filename
Deletion removes name, not necessarily data immediately
```

---

# 9. System Monitoring

## 9.1 Experiment

```bash
top
```

## 9.2 Observations

* Majority processes in `S` state
* CPU usage dropped after stopping `yes`

## 9.3 Analysis

```
CPU usage is demand-driven
Scheduler runs only runnable processes
```

---
