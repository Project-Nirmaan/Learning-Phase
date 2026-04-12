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
