# Week-2 Notes — Topic-1: Process Inspection & Control

---

# 1. Objective

To understand how a running Linux system manages execution through:

* Processes as kernel-managed entities
* Process lifecycle and hierarchy
* Resource ownership (CPU, memory, files)
* Process states and scheduling behavior
* Mechanisms to observe and control processes

---

# 2. First Principles: What is a Process?

A process is not just a program.

It is an **execution context** defined as:

```
Process =
    Code (instructions)
  + Data (memory)
  + CPU state (registers, program counter)
  + Kernel metadata (PID, permissions, file descriptors)
```

---

## Key Insight

* CPU does NOT understand processes
* CPU executes instructions only
* **Process is a kernel abstraction**

---

# 3. Process Creation Flow

Execution begins in user space but is controlled by the kernel.

```
Shell
  ↓
fork()        → duplicate process
  ↓
execve()      → load new program
  ↓
Kernel creates process structure
  ↓
Scheduler runs process
```

---

## Critical Insight

```
Process = Kernel data structure + scheduled execution
```

---

# 4. Dual Process Worlds

The system contains two independent process hierarchies:

## 4.1 User Space Process Tree

```
PID 1 (init/systemd)
   ├── services (cron, sshd, dbus)
   ├── login
   │     └── bash
   │           └── user programs
```

## 4.2 Kernel Thread Tree

```
PID 2 (kthreadd)
   ├── kworker
   ├── ksoftirqd
   ├── rcu threads
   ├── memory management threads
```

---

## Key Insight

* PID 1 → root of user-space processes
* PID 2 → root of kernel threads
* Kernel and user space are strictly separated

---

# 5. Process Hierarchy (Parent–Child Model)

Each process has:

* PID (Process ID)
* PPID (Parent Process ID)

---

## Example (Observed System)

```
init (PID 1)
 └── sshd
      └── sshd-session
           └── sh
                └── node (VSCode server)
                     └── child node processes
```

---

## Insight

```
No process exists independently
Every process originates from another process
```

---

# 6. Multi-Process Applications

Modern applications are not single processes.

Example: VSCode server

```
node (main)
 ├── extension host
 ├── file watcher
 ├── terminal handler
```

---

## Insight

```
Application = Process Ecosystem
```

---

# 7. Process States

Observed via STAT column:

| State | Meaning                             |
| ----- | ----------------------------------- |
| R     | Running                             |
| S     | Sleeping (waiting for event)        |
| D     | Uninterruptible sleep (kernel wait) |
| T     | Stopped                             |
| Z     | Zombie                              |

---

## 7.1 Sleeping (S)

* Process is waiting (timer, input, etc.)
* Not using CPU

---

## 7.2 Running (R)

* Currently executing on CPU
* Rare compared to sleeping processes

---

## 7.3 Uninterruptible Sleep (D)

* Waiting for kernel operation (e.g., disk I/O)
* Cannot be interrupted safely

---

## 7.4 Zombie (Z)

* Process finished execution
* Parent has not collected exit status

---

## Key Insight

```
Most processes are NOT running
They are waiting
```

---

# 8. CPU Utilization Behavior

Observation:

* Majority of processes are in `S` state
* CPU usage often very low

---

## Explanation

### Example: sleep 180

* Calls `nanosleep()`
* Kernel suspends process
* Process removed from scheduler

```
CPU usage = 0%
```

---

## Contrast: Active Process (Node)

* Event loop constantly active
* Handles I/O, extensions, background tasks

```
CPU usage > 0%
```

---

## Insight

```
Execution ≠ CPU usage
Processes can exist without running
```

---

# 9. File Descriptors & Process Link

From experiments:

* A process holds file descriptors (FDs)
* FD points to inode

---

## Important Behavior

```
rm file.txt
```

* Removes filename (directory entry)
* Does NOT remove inode immediately

If process still holds FD:

```
File continues to exist
```

---

## Insight

```
File lifetime depends on:
    link_count AND open file descriptors
```

---

# 10. Process Inspection Tools (With Meaning)

---

## 10.1 ps

* Reads `/proc` filesystem
* Snapshot of process table

```
ps = static snapshot
```

---

## 10.2 top

* Continuously polls kernel
* Displays real-time stats

```
top = dynamic monitoring
```

---

## 10.3 pstree

* Displays process hierarchy
* Reveals parent-child relationships

---

## 10.4 lsof

* Lists open files by processes

```
Everything is a file:
    files, sockets, pipes, devices
```

---

## 10.5 kill

* Sends signal (NOT necessarily kill)

```
kill → signal delivery
```

| Signal  | Meaning              |
| ------- | -------------------- |
| SIGTERM | Graceful termination |
| SIGKILL | Force termination    |
| SIGSTOP | Pause                |
| SIGCONT | Resume               |

---

## 10.6 nice / renice

* Adjust scheduling priority

```
Lower nice value → higher priority
```

---

# 11. Kernel vs User Processes

---

## Kernel Threads

* Shown as `[name]`
* No executable file
* Run entirely in kernel space
* No separate virtual memory (VSZ = 0)

---

## User Processes

* Have executable path
* Own virtual memory
* Run in user space

---

## Insight

```
Kernel threads are internal OS workers
User processes are external workloads
```

---

# 12. Scheduling & Resource Control

---

## Scheduler Role

* Decides which process runs
* Based on:

  * priority
  * fairness
  * CPU availability

---

## Important Behavior

* Processes voluntarily give up CPU (sleep)
* Kernel forces context switches

---

## Insight

```
CPU is shared
Kernel enforces fairness
```

---

# 13. Critical Edge Cases

---

## 13.1 Zombie Processes

Cause:

* Parent does not call `wait()`

Impact:

* Occupies PID table

---

## 13.2 Unkillable Processes (D state)

Cause:

* Waiting for kernel I/O

Impact:

* Cannot terminate immediately

---

## 13.3 Signal Ignoring

* Processes may ignore SIGTERM
* SIGKILL is final fallback

---

## 13.4 Hidden Resource Usage

* Background processes (e.g., VSCode) consume CPU/memory
* Not always visible without inspection

---

# 14. Key Insights from Experiments

---

## Insight 1

```
Processes spend most time waiting, not executing
```

---

## Insight 2

```
System is event-driven, not CPU-driven
```

---

## Insight 3

```
Applications are process trees, not single processes
```

---

## Insight 4

```
Kernel and user space are strictly separated execution domains
```

---

## Insight 5

```
File and process lifetimes are interconnected via descriptors
```

---

# 15. Common Misconceptions

---

### ❌ “Process = program”

→ Incorrect
Process = execution context

---

### ❌ “kill always kills”

→ Incorrect
kill sends signals

---

### ❌ “High CPU = many processes”

→ Incorrect
Few active processes can dominate CPU

---

### ❌ “Deleting file removes it immediately”

→ Incorrect
Depends on references

---

# 16. Final Mental Model

```
CPU executes instructions
Kernel manages processes
Processes hold resources
Scheduler controls execution
Signals control behavior
```

---

# 17. Outcome of Topic-1

After this topic, we can:

* Interpret real system state
* Trace process hierarchy
* Understand process lifecycle
* Diagnose CPU and process behavior
* Connect filesystem and process behavior
* Reason about system execution instead of memorizing commands

---
