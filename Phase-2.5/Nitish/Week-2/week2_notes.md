# Week-2 Notes

---

# Topic-1: Process Inspection & Control

---

# 1. Objective

To understand how a running Linux system manages execution through:

* Processes as kernel-managed entities
* Process lifecycle and hierarchy
* Resource ownership (CPU, memory, files)
* Process states and scheduling behavior
* Mechanisms to observe and control processes

---

# 2. What is a Process?

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

# 16. Finally we conclude :-

```
CPU executes instructions
Kernel manages processes
Processes hold resources
Scheduler controls execution
Signals control behavior
```

---

After this topic, we can:

* Interpret real system state
* Trace process hierarchy
* Understand process lifecycle
* Diagnose CPU and process behavior
* Connect filesystem and process behavior
* Reason about system execution instead of memorizing commands

---

# Topic-2: Foreground & Background Jobs

---

# 1. Objective

To understand how Linux systems manage **interactive execution** through:

* Shell-level job abstraction
* Kernel-level process control
* Terminal ownership and access rules
* Signal-driven control (SIGINT, SIGTSTP, SIGTTIN, etc.)
* Behavior differences between foreground and background execution

---

# 2. First Principles: Job vs Process

---

## 2.1 Process (Kernel Abstraction)

A process is:

```
An execution context managed by the kernel
```

Identified by:

* PID (Process ID)
* Managed by scheduler
* Holds memory, file descriptors, CPU state

---

## 2.2 Job (Shell Abstraction)

A job is:

```
A shell-managed reference to one or more processes
associated with a terminal
```

Identified by:

* Job ID: %1, %2, etc.
* Stored in shell’s job table

---

## Key Distinction

```
Process → Kernel entity (real execution)
Job     → Shell entity (user interaction layer)
```

---

# 3. Two Control Systems

---

## 3.1 Kernel Responsibilities

* Process creation (fork, exec)
* Scheduling
* Signal delivery
* Resource management

---

## 3.2 Shell Responsibilities

* Job tracking
* Terminal assignment
* Mapping job IDs ↔ process groups
* Sending control signals (fg, bg)

---

## Insight

```
Shell manages interaction
Kernel manages execution
```

---

# 4. Terminal as a Resource

---

## Core Idea

```
Terminal is a shared resource (like CPU or memory)
```

---

## Key Property

```
Only ONE process group can control the terminal at a time
```

---

## Foreground Process Group (FGPGID)

Kernel tracks:

```
Foreground Process Group ID
```

This group has:

* Access to stdin (keyboard)
* Control over terminal input/output

---

# 5. Foreground Execution

---

## Definition

```
Foreground job = process group that owns the terminal
```

---

## Behavior

* Receives keyboard input
* Can read from stdin
* Can receive terminal-generated signals

---

## Example

```bash
sleep 100
```

* Terminal is blocked
* Process owns terminal

---

## Insight

```
Foreground = terminal ownership, not execution priority
```

---

# 6. Background Execution

---

## Definition

```
Background job = process running without terminal control
```

---

## Behavior

* Executes normally
* Cannot interact with terminal
* Runs concurrently with shell

---

## Example

```bash
sleep 100 &
```

Output:

```
[1] 3050
```

* [1] → job ID
* 3050 → PID

---

## Insight

```
Background ≠ separate execution model
Background = restricted terminal interaction
```

---

# 7. Job Control Commands (Behavioral View)

---

## 7.1 `&` — Run in Background

* Shell creates process
* Does NOT assign terminal
* Adds entry to job table

---

## 7.2 `jobs`

* Displays shell’s job table
* Does NOT query kernel

---

## 7.3 `fg %n`

* Transfers terminal control to job
* Uses `tcsetpgrp()` internally

---

## 7.4 `bg %n`

* Sends SIGCONT
* Keeps process in background

---

## 7.5 `disown %n`

* Removes job from shell tracking
* Process continues independently

---

## Insight

```
jobs ≠ ps
jobs → shell state
ps   → kernel state
```

---

# 8. Signals and Terminal Interaction

---

## Terminal-Generated Signals

| Action   | Signal  |
| -------- | ------- |
| Ctrl + C | SIGINT  |
| Ctrl + Z | SIGTSTP |

---

## Job Control Signals

| Signal  | Purpose                  |
| ------- | ------------------------ |
| SIGSTOP | Force stop               |
| SIGCONT | Resume                   |
| SIGTTIN | Background read attempt  |
| SIGTTOU | Background write attempt |

---

## Insight

```
Terminal does not send commands
It sends signals
```

---

# 9. Terminal Access Rules (Critical)

---

## Rule 1: Reading from Terminal

```
Only foreground process group can read from terminal
```

---

### Violation

Background process tries:

```bash
cat &
```

---

### Result

```
Kernel sends SIGTTIN → process STOPPED
```

---

## Rule 2: Writing to Terminal

* Usually allowed
* May trigger SIGTTOU in strict conditions

---

## Insight

```
Kernel enforces terminal access, not shell
```

---

# 10. Input/Output Redirection Interaction

---

## Key Principle

```
stdin, stdout, stderr are independent
```

---

## Cases

---

### Case 1

```bash
cat &
```

* stdin → terminal
* ❌ STOP (SIGTTIN)

---

### Case 2

```bash
cat < file &
```

* stdin → file
* ✅ works

---

### Case 3

```bash
cat > file &
```

* stdin → terminal
* ❌ STOP

---

### Case 4

```bash
cat < input.txt > output.txt &
```

* stdin → file
* stdout → file
* ✅ works

---

## Insight

```
Failure depends on terminal usage, not background execution
```

---

# 11. Process Groups (Advanced Concept)

---

## Definition

```
A process group = collection of related processes (job)
```

---

## Purpose

* Signal delivery to multiple processes
* Pipeline management

---

## Example

```bash
cmd1 | cmd2
```

* Multiple processes
* Single process group
* Controlled as one job

---

## Insight

```
Job = Process Group abstraction in shell
```

---

# 12. Lifecycle of a Job (Observed Flow)

---

```
Command typed
  ↓
Shell parses input
  ↓
fork()
  ↓
execve()
  ↓
Process created (PID)
  ↓
Shell assigns job ID
  ↓
Foreground or background decision
  ↓
Terminal ownership assigned or withheld
```

---

# 13. Edge Cases & Observations

---

## 13.1 Background Process Stops Automatically

Cause:

```
Attempt to read from terminal → SIGTTIN
```

---

## 13.2 Foreground Recovery

```
fg %n → restores terminal access
```

---

## 13.3 Disowned Processes

* Continue running after terminal closes
* Shell loses control

---

## 13.4 Multiple Background Jobs

* Managed independently in shell
* Visible via `jobs`

---

## 13.5 Terminal Dependency

Programs requiring input (e.g., cat, vim):

* Fail in background without redirection

---

# 14. Key Insights from Experiments

---

## Insight 1

```
Foreground vs background is about terminal control,
not execution behavior
```

---

## Insight 2

```
Kernel enforces terminal access rules using signals
```

---

## Insight 3

```
Shell is only a controller, not an enforcer
```

---

## Insight 4

```
Redirection changes behavior more than backgrounding
```

---

## Insight 5

```
Process groups enable unified control of multiple processes
```

---

# 15. Common Misconceptions

---

### ❌ “Background process has no terminal”

→ Incorrect
It has terminal, but lacks control

---

### ❌ “& makes program faster”

→ Incorrect
Only changes interaction, not execution speed

---

### ❌ “jobs shows all processes”

→ Incorrect
Only shell-managed jobs

---

### ❌ “cat stops because it cannot read”

→ Incorrect
Kernel stops it due to access violation

---

# 16. Finally we conclude :-

---

```
Shell:
  tracks jobs
  assigns job IDs
  controls terminal ownership

Kernel:
  runs processes
  enforces access rules
  delivers signals

Terminal:
  shared resource
  controlled by foreground process group
```

---

# 17. Outcome of Topic-2

After this topic, we can:

* Distinguish job vs process clearly
* Understand terminal ownership
* Predict behavior of foreground/background commands
* Diagnose stopped jobs and signal behavior
* Control execution using fg, bg, disown
* Reason about shell vs kernel responsibilities

---

# Topic-3: Signals (Deep Systems Reference)

---

# 1. Objective

To understand **signals as the asynchronous control mechanism** used by the kernel to:

* Interrupt process execution
* Control process lifecycle (stop, continue, terminate)
* Enforce terminal access rules
* Integrate with system calls (EINTR)
* Coordinate execution across process groups

---

# 2. First Principles

---

## 2.1 What is a Signal?

```text
Signal = asynchronous notification sent by the kernel to a process
```

---

## 2.2 Key Properties

| Property      | Meaning                                 |
| ------------- | --------------------------------------- |
| Asynchronous  | Can occur at any time                   |
| Kernel-driven | Sent by kernel or via syscall           |
| Interruptive  | Can disrupt execution                   |
| Non-blocking  | Delivered independently of process flow |

---

## 2.3 Correct Mental Model

```text
Signal ≠ command
Signal = interrupt-like event
```

---

# 3. Hardware → Kernel → Process Flow

---

## Full Pipeline

```text
Hardware Event (keyboard, timer, I/O)
   ↓
CPU Interrupt
   ↓
Kernel Handler
   ↓
Signal Generated
   ↓
Delivered to Process / Process Group
```

---

## Example: Ctrl+C

```text
Keyboard interrupt
→ Kernel detects Ctrl+C
→ Sends SIGINT to foreground process group
```

---

# 4. Signal Representation Inside Kernel

---

## Important Insight

```text
Signals are NOT immediately executed
Signals are stored as state
```

---

## Conceptual Structure

```text
task_struct {
    pending_signals
    blocked_signals (mask)
    signal_handlers
}
```

---

## Meaning

```text
Signal delivery = marking signal as pending
Signal handling = processing it later
```

---

# 5. Signal Delivery Mechanism

---

## Step-by-Step

```text
1. Event occurs
2. Kernel determines target (PID or process group)
3. Signal marked as pending
4. Process reaches safe execution point
5. Signal is handled
```

---

## Critical Insight

```text
Signal delivery is deferred, not instantaneous
```

---

# 6. Default Signal Actions

---

| Signal  | Default Action  |
| ------- | --------------- |
| SIGINT  | Terminate       |
| SIGTERM | Terminate       |
| SIGKILL | Force terminate |
| SIGSTOP | Stop            |
| SIGCONT | Continue        |
| SIGTSTP | Stop (terminal) |

---

## Key Distinction

```text
SIGTERM → request
SIGKILL → enforcement
```

---

# 7. Signal Handling Behavior

---

## A process can:

```text
1. Use default action
2. Ignore signal
3. Catch and handle signal
```

---

## Exception (Critical)

```text
SIGKILL and SIGSTOP cannot be ignored or caught
```

---

## Why?

```text
Kernel must retain ultimate control over all processes
```

---

# 8. Signal Categories

---

## 8.1 Standard Signals

Examples:

```text
SIGINT, SIGTERM, SIGSTOP
```

---

### Behavior

```text
Not queued
Multiple occurrences collapse into one
```

---

## 8.2 Real-Time Signals

```text
SIGRTMIN → SIGRTMAX
```

---

### Behavior

```text
Queued
Delivered in order
No merging
```

---

## Key Insight

```text
Standard signals = flag
Real-time signals = queue
```

---

# 9. Signals and Process States

---

| Signal  | State Transition      |
| ------- | --------------------- |
| SIGSTOP | Running → Stopped (T) |
| SIGCONT | Stopped → Running     |
| SIGTERM | Running → Terminated  |
| SIGKILL | Immediate termination |

---

## Important State

```text
T → stopped (not running, not sleeping)
```

---

# 10. Signals and Process Groups

---

## Key Concept

```text
Signals are often delivered to process groups
```

---

## Example

```text
Ctrl+C → sent to foreground process group
```

---

## Insight

```text
Signal targeting is based on grouping, not parent-child hierarchy
```

---

# 11. Signals vs System Calls

---

## System Call

```text
Process → Kernel request
```

---

## Signal

```text
Kernel → Process notification
```

---

## Insight

```text
Syscall = synchronous
Signal  = asynchronous
```

---

# 12. EINTR — Interrupted System Calls

---

## Definition

```text
EINTR = system call interrupted by signal
```

---

## Execution Flow

```text
Process calls read()
↓
Kernel blocks waiting
↓
Signal arrives
↓
Kernel interrupts syscall
↓
Returns -1, errno = EINTR
```

---

## Key Insight

```text
Signals interrupt execution, not just processes
```

---

## Correct Handling Pattern

```c
while ((n = read(fd, buf, size)) == -1 && errno == EINTR) {
    // retry
}
```

---

## Important Principle

```text
EINTR is not failure
It is interruption
```

---

# 13. Signal Masking

---

## Concept

```text
Processes can block signals using a mask
```

---

## Behavior

```text
Blocked signal → remains pending
Delivered later when unblocked
```

---

## Exception

```text
SIGKILL, SIGSTOP cannot be masked
```

---

# 14. fork() and Signal Behavior

---

## Inheritance

Child inherits:

```text
✔ signal handlers
✔ signal mask
✔ process group
✔ terminal association
```

---

## Insight

```text
fork copies signal configuration
exec resets most handlers
```

---

# 15. exec() and Signals

---

## Behavior

```text
exec replaces program
signal handlers reset to default (mostly)
```

---

## Insight

```text
fork → copy behavior
exec → reset behavior
```

---

# 16. Terminal-Generated Signals

---

| Action | Signal  |
| ------ | ------- |
| Ctrl+C | SIGINT  |
| Ctrl+Z | SIGTSTP |

---

## Special Signals

| Signal  | Meaning                  |
| ------- | ------------------------ |
| SIGTTIN | Background read attempt  |
| SIGTTOU | Background write attempt |

---

## Insight

```text
Terminal enforces access via signals
```

---

# 17. SIGHUP (Session Termination)

---

## When triggered

```text
Terminal closes
```

---

## Behavior

```text
Sent to process group
Default → terminate
```

---

## Solutions

```bash
nohup command &
disown
```

---

## Insight

```text
Process lifetime can depend on terminal session
```

---

# 18. Practical Observations (From Experiments)

---

## Observation 1

```text
Multiple SIGINT → only one delivered
```

---

## Observation 2

```text
SIGSTOP always works
SIGINT may be ignored
```

---

## Observation 3

```text
Signal order affects final state
```

---

## Observation 4

```text
trap affects shell, not external programs
```

---

## Observation 5

```text
Signals delivered to process groups, not just processes
```

---

# 19. Edge Cases

---

## 19.1 Ignored Signals

```text
Process may ignore SIGINT or SIGTERM
```

---

## 19.2 Unkillable Process (D State)

```text
Stuck in kernel → cannot process signals
```

---

## 19.3 Zombie Processes

```text
Signal handled, process exited
Parent did not reap
```

---

## 19.4 Signal Race Conditions

```text
Multiple signals → order-dependent behavior
```

---

# 20. Deep System Insights

---

## Insight 1

```text
Signals are kernel-level control plane
```

---

## Insight 2

```text
Signal delivery ≠ signal handling
```

---

## Insight 3

```text
Execution is interruptible at any time
```

---

## Insight 4

```text
Process groups define control boundaries
```

---

## Insight 5

```text
Kernel enforces authority via non-maskable signals
```

---

# 21. Final Mental Model

---

```text
Process executes
   ↓
Kernel event occurs
   ↓
Signal marked pending
   ↓
Process reaches safe point
   ↓
Handler executes (or default action)
   ↓
Execution resumes / stops / exits
```

---

# 22. Outcome of Topic-3

After this topic, we can:

* Explain signal delivery pipeline
* Understand process control via signals
* Predict behavior of Ctrl+C, Ctrl+Z, kill
* Handle EINTR in system programs
* Understand signal inheritance (fork/exec)
* Debug real-world failures caused by signals
* Reason about asynchronous OS behavior

---
# Topic-4: Command Execution & PATH

---

## 1. Why This Topic Matters

```
Typing a command → triggers a full hardware–software interaction chain
```

This is not “running a program”.
This is:

* Parsing language (shell)
* Process creation (kernel abstraction)
* Memory replacement (execve)
* Binary loading (ELF)

---

## 2. First-Principles Mental Model

### Core Separation

| Layer  | Responsibility |
| ------ | -------------- |
| Shell  | Interpretation |
| Kernel | Execution      |

---

### Critical Invariant

```
Shell never executes programs
Kernel always executes programs
```

Shell only *requests* execution via system calls.

---

## 3. Full Execution Pipeline (Precise)

```
User types command
↓
Shell reads input (stdin)
↓
Lexical analysis (tokenization)
↓
Alias expansion (text substitution)
↓
Parsing (syntax tree creation)
↓
Command resolution
↓
fork() → create child process
↓
execve() → replace child memory
↓
Kernel loads binary (ELF)
↓
Program starts at entry point
```

---

## 4. Command Resolution (Deeper View)

Shell must answer:

```
“What does this token represent?”
```

### Resolution Order (Strict)

```
1. Alias
2. Function
3. Built-in
4. External binary (PATH search)
```

---

### Why This Order Exists

* Alias → user convenience
* Function → programmable behavior
* Built-in → must modify shell state
* Binary → external execution

---

## 5. Built-in vs External (Critical Distinction)

### Built-in Example: cd

Why not external?

Because:

```
cd must change current process state
```

If implemented as external:

```
child process changes directory → exits → useless
```

---

### Key Insight

```
Anything that modifies shell state MUST be builtin
```

Examples:

* cd
* export
* alias
* jobs

---

### External Commands

Examples:

* ls
* cat
* grep

These:

* Do not modify shell state
* Can safely run in child process

---

## 6. PATH – Not Just a Variable

### Definition

```
PATH = ordered search list for executables
```

---

### Example

```
PATH=/usr/local/bin:/usr/bin:/bin
```

---

### Search Algorithm

For command `ls`:

```
for dir in PATH:
    if dir/ls exists and executable:
        execute it
        stop
```

---

### Key Insight

```
PATH defines execution priority
```

---

## 7. PATH as a Security Boundary

### Dangerous Configuration

```
PATH=.:$PATH
```

Why dangerous?

Because:

```
./ls overrides /bin/ls
```

---

### Real Risk

* Malicious binaries
* Privilege escalation
* PATH hijacking attacks

---

### Engineering Rule

```
Never trust PATH blindly
```

---

## 8. fork() – Process Creation

### What fork() Actually Does

Creates a new process with:

* Same code
* Same memory (copy-on-write)
* Same file descriptors

---

### After fork()

Two processes exist:

```
Parent (shell)
Child (future command)
```

---

### Key Insight

```
fork duplicates context, not execution purpose
```

---

## 9. execve() – The Most Important Boundary

### Definition

```
execve(path, argv, envp)
```

---

### What It Does

```
DESTROYS current process memory
REPLACES with new program
```

---

### Important Consequences

* No return on success
* Same PID, new program
* Stack, heap, code replaced

---

### Key Insight

```
execve transforms process identity without changing PID
```

---
