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

# 10. System Call Tracing

## 10.1 Experiment

```bash
strace ls
```

## 10.2 Observations

Key system calls:

* `execve()` → process execution
* `openat()` → file access
* `read()` → data fetch
* `write()` → output to terminal
* `mmap()` → memory mapping

## 10.3 Analysis

### Execution Flow

```
User command (ls)
→ shell resolves path
→ execve()
→ kernel loads binary
→ process executes syscalls
→ kernel interacts with filesystem
→ output returned to user
```

### Key Insight

```
User space NEVER directly accesses hardware
All interaction happens via system calls
```

---

# 11. Key Learnings

## 11.1 Process Model

```
Process = execution context + kernel-managed resources
```

## 11.2 Scheduling

* Most processes are waiting
* CPU time is allocated dynamically

## 11.3 Signals

* Core mechanism for process control
* Delivered by kernel

## 11.4 Shell vs Kernel Boundary

```
Shell → user interface
Kernel → system authority
```

## 11.5 Filesystem Behavior

* Name and data are separate
* File lifetime depends on references

## 11.6 System Calls

```
System calls = only legal interface to kernel
```

---

# 12. Final Concept Map

```
User Command
    ↓
Shell (parsing + PATH resolution)
    ↓
execve()
    ↓
Kernel
    ↓
Process creation
    ↓
Scheduler
    ↓
Execution
    ↓
System Calls (read, write, open)
    ↓
Hardware interaction
```

---

# 13. Conclusion

This assignment established a **practical understanding of how a Linux system operates internally**:

* Processes are not programs, but **kernel-managed execution environments**
* CPU scheduling is **selective and demand-driven**
* Signals are the **primary control interface for processes**
* The shell provides a **layer of abstraction**, but real control lies in the kernel
* Filesystem and process models are deeply interconnected
* System calls form the **strict boundary between user space and kernel space**

---

# 14. Improvements

* `pstree` and `killall` were not available → need installation (`psmisc`)
* File descriptor experiment could be improved with:

  ```bash
  tail -f file.txt
  ```
* More structured logging for process state transitions can be added

---

**End of Report**
