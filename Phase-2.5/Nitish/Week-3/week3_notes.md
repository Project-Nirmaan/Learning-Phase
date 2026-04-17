# Week-3 Notes — Streams, File Descriptors & Redirection

---

# Objective

This week is not about memorizing shell commands.

I am trying to understand how a process actually interacts with the outside world and how the shell influences that interaction without modifying the program itself.

If I get this right, I should be able to:

* Build a minimal shell using fork, exec, and dup2
* Debug real system-level issues
* Understand system calls with clarity instead of memorization

---

# Topic-1: Standard Streams & File Descriptors

---

## 1. The Problem I am Solving

The CPU only executes instructions.

But programs need to:

* Take input (keyboard, file, pipe, network)
* Produce output (terminal, file, logs)

Hardware is different for each of these. Direct interaction would make programs complex and unsafe.

So the operating system provides a uniform abstraction.

---

## 2. Core Idea

In UNIX-like systems, everything is treated as a file.

That means a program does not care whether it is reading from a keyboard or a file. It just performs:

read()
write()

This simplifies both program design and system design.

---

## 3. File Descriptor

A file descriptor is an integer index maintained by the kernel for each process.

Each process has its own file descriptor table.

Typical layout:

0 → stdin
1 → stdout
2 → stderr

These are created when a process starts.

---

## 4. Internal Mapping

A file descriptor is not the file itself.

The actual mapping looks like this:

FD → file object → inode / device

* The FD is just an index
* The file object stores state like offset and mode
* The inode or device represents actual data

This is consistent with how the filesystem works where names map to inodes.

---

## 5. What a Program Actually Does

A program does not print to the screen.

It writes to a file descriptor.

Example:

write(1, "hello", 5)

If FD 1 is connected to the terminal, I see output on the screen.
If it is connected to a file, the output goes to the file.

---

## 6. Experiment: Writing to stdout

```c
#include <unistd.h>

int main() {
    write(1, "Hello\n", 6);
    return 0;
}
```

Compile and run:

```
gcc test.c -o test
./test
```

Now redirect:

```
./test > out.txt
```

The program is unchanged, but the output location changes.

This confirms that output destination is controlled externally.

---

## 7. Experiment: stdout vs stderr

```c
#include <unistd.h>

int main() {
    write(1, "stdout\n", 7);
    write(2, "stderr\n", 7);
}
```

Run:

```
./test > out.txt
```

stdout goes to the file.
stderr still appears on the terminal.

This shows that they are handled separately.

---

## 8. Why stdout and stderr are Separate

Keeping them separate allows:

* Clean data output (stdout)
* Independent error reporting (stderr)

This becomes important in scripting and debugging.

---

## 9. Edge Cases

* If FD 1 is closed, output may fail silently
* File descriptors can be reused after closing
* Multiple descriptors can refer to the same file, sharing offsets

---

# Topic-2: Redirection

---

## 1. The Real Question

If programs are not deciding where output goes, then what is?

The answer is the shell.

---

## 2. What Redirection Means

Redirection is the process of modifying file descriptors before executing a program.

It does not change the program itself.

---

## 3. Execution Flow

For the command:

```
ls > out.txt
```

The shell performs:

1. open("out.txt")
2. dup2(fd, 1)
3. exec(ls)

After exec, the program runs normally but writes to the modified FD.

---

## 4. dup2 Mechanism

```
dup2(old_fd, new_fd)
```

This replaces new_fd with old_fd.

It is the core mechanism behind redirection.

---

## 5. Experiment: Manual Redirection in C

```c
#include <unistd.h>
#include <fcntl.h>

int main() {
    int fd = open("out.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644);
    dup2(fd, 1);

    write(1, "Redirected\n", 11);
    return 0;
}
```

Running this program writes output to the file instead of the terminal.

---

## 6. stdout and stderr Redirection

```
ls > out.txt 2> err.txt
```

stdout is written to out.txt
stderr is written to err.txt

---

## 7. Merging Output

```
ls > file 2>&1
```

stderr is redirected to wherever stdout is currently pointing.

---

## 8. Order Matters

```
ls > file 2>&1
```

and

```
ls 2>&1 > file
```

produce different results.

This happens because redirection is processed from left to right.

---

## 9. Input Redirection

```
cat < file.txt
```

The shell replaces stdin (FD 0) with the file.

---

## 10. Using /dev/null

```
ls > /dev/null
```

This discards output.

Useful for:

* silent execution
* testing

---

## 11. Verifying Using strace

```
strace ls > out.txt
```

This shows:

* open()
* dup2()
* write()

It confirms what is happening at the system call level.

---

## 12. Edge Cases

* Incorrect order of redirection leads to unexpected behavior
* Files may get overwritten unintentionally
* Redirecting everything to /dev/null can hide errors
* Forgetting to close file descriptors can lead to leaks

---

# Topic-3: Pipes & Pipelines

---

## 1. The Problem I am Solving

I already know:

* Programs write to stdout (FD 1)
* Programs read from stdin (FD 0)

Now the question becomes:

How do I connect one program’s output directly into another program’s input without using files?

---

## 2. Basic Idea of a Pipe

Using a pipe:

```
cmd1 | cmd2
```

means:

* stdout of cmd1 becomes stdin of cmd2

There is no intermediate file involved.

---

## 3. Approach and Thinking

```
cmd1 → cmd2
```

More accurately:

```
cmd1 (FD 1) → pipe → cmd2 (FD 0)
```

The shell sets up this connection.

---

## 4. Experiment: Basic Pipeline

```
echo "hello world" | wc -w
```

Output:

2

Explanation:

* echo writes to stdout
* wc reads from stdin

---

## 5. Comparing with File-Based Flow

```
echo "hello world" > file.txt
wc -w < file.txt
```

Same result, but:

* file-based → disk involved
* pipe → in-memory stream

---

## 6. Pipelines Run Concurrently

```
yes | head -n 5
```

Observation:

* yes produces infinite output
* head stops after 5 lines
* yes gets terminated automatically

This only works because both processes run at the same time.

---

## 7. Order vs Dependency

```
sleep 5 | echo done
```

Output appears immediately.

Reason:

* echo does not depend on input
* it executes independently

Pipeline behavior depends on data dependency, not command order.

---

## 8. Multi-Stage Pipelines

```
ps aux | grep bash | wc -l
```

Flow:

* ps generates data
* grep filters it
* wc counts it

Each stage is a separate process.

---

## 9. stderr is NOT part of pipe by default

```
ls non_existing | grep something
```

Error still appears on terminal.

Because:

* pipe only connects stdout

To include stderr:

```
ls non_existing 2>&1 | grep something
```

---

## 10. Combining Pipes with Redirection

```
ls | grep txt > out.txt
```

Flow:

ls → grep → file

---

## 11. Debugging Pipelines

Break pipeline into parts:

```
ps aux
ps aux | grep bash
```

Insert cat:

```
ps aux | cat | grep bash
```

This helps observe intermediate data.

---

## 12. Subshell Behavior

```
echo hello | read var
echo $var
```

Result:

var is empty

Reason:

* each pipeline stage runs in a subshell
* variables do not propagate back to parent shell

---

## 13. Buffering Behavior

Some programs buffer output when used in pipelines.

Example:

```
python script.py | grep something
```

Output may be delayed.

Reason:

* stdout is not terminal → buffering enabled

---

## 14. tee Command

```
echo "hello" | tee file.txt
```

Writes to:

* file
* stdout

Used when output needs to be both saved and passed forward.

---

## 15. xargs Command

```
echo "file.txt" | xargs cat
```

Converts stream input into command arguments.

Useful when commands expect arguments instead of stdin.

---

## 16. Blocking Behavior

If producer is faster than consumer:

* producer blocks

If consumer is faster:

* waits for data

This keeps system stable.

---

## 17. Broken Pipe

```
yes | head -n 1
```

* head exits early
* yes tries writing
* gets terminated

---

## 18. Failure Handling

```
false | true
```

Exit status:

```
echo $?
```

Returns success because only last command is considered.

To handle properly:

```
set -o pipefail
```

---

## 19. Edge Cases

* Subshell variable loss
* Unexpected buffering
* Ignored errors in pipelines
* Infinite producers
* Hanging due to improper input/output expectations

---

# Final Conclusion

```
cmd1 | cmd2 | cmd3
```

Is actually:

```
Process1 → pipe → Process2 → pipe → Process3
```

Where:

* each process runs independently
* shell connects file descriptors
* kernel manages data flow

---

# Topic-4: Exit Codes & Conditional Execution

---

## 1. What Problem I Am Solving

When a process finishes execution, the system must communicate whether it succeeded or failed.

Without this mechanism:

* Automation would not be possible
* Scripts would execute blindly
* There would be no reliable way to make decisions based on outcomes

So the system needs a minimal, consistent way to propagate execution results.

---

## 2. Core Idea

A process communicates its result to the operating system using an exit status.

Internally:

* A process calls `exit(status)`
* The kernel stores this status in the process structure
* The parent retrieves it using `wait()` / `waitpid()`

This is a kernel-level contract, not a shell feature.

---

## 3. Convention Used by UNIX Systems

```
0   → success
≠0  → failure or alternate outcome
```

This is a convention adopted across user-space programs.

Different programs may assign different meanings to non-zero values.

---

## 4. Mental Model

Command execution produces two independent outputs:

* Human-facing output → stdout / stderr
* Machine-facing output → exit code

The shell does not interpret printed output for logic.
It relies entirely on exit codes.

---

## 5. Observing Exit Codes

```
echo $?
```

This retrieves the exit status of the last executed command.

This value is maintained by the shell and updated after every command execution.

---

## 6. Process Lifecycle Connection

Execution flow:

```
fork()
  → exec()
  → run
  → exit(status)
  → waitpid() collects status
```

The shell is simply acting as a parent process that:

* spawns children
* waits for them
* uses their exit codes

---

## 7. Conditional Execution in Shell

The shell converts exit codes into control flow.

### AND Operator

```
cmd1 && cmd2
```

* `cmd2` executes only if `cmd1` returns success (0)

---

### OR Operator

```
cmd1 || cmd2
```

* `cmd2` executes only if `cmd1` fails (non-zero)

---

### Combined Logic

```
make && echo "Build success" || echo "Build failed"
```

The shell chains execution based on exit code propagation.

---

## 8. Behavior is Short-Circuit Based

* `&&` stops on first failure
* `||` stops on first success

This mirrors boolean logic evaluation.

---

## 9. Edge Cases and Observations

### Non-zero Does Not Always Mean Error

Example:

```
grep "pattern" file
```

* `0` → match found
* `1` → no match

The system is working correctly, but semantics differ.

---

### Pipeline Exit Behavior

```
cmd1 | cmd2
```

Default behavior:

* Exit status = exit status of `cmd2`

Upstream failures are ignored.

---

### Enabling Accurate Failure Propagation

```
set -o pipefail
```

Now:

* Pipeline fails if any command fails

---

### Subshell Interaction

```
echo hello | read var
```

* `read` runs in a subshell
* Variable changes do not propagate to parent shell

---

### Command Substitution Behavior

```
var=$(false)
```

* Exit code belongs to assignment context
* Can lead to confusion if not checked explicitly

---

## 10. Engineering Insight

Exit codes form a minimal signaling mechanism between processes.

They allow:

* composability
* automation
* predictable control flow

Without exit codes, the shell could not function as an orchestration layer.

---

# Topic-5: Observing Internals

---

## 1. What Problem I Am Solving

The operating system hides complexity through abstractions.

However, debugging and systems development require visibility into:

* what the kernel is doing
* how processes interact
* how data flows through the system

So I need tools and methods to observe internal behavior.

---

## 2. Core Idea

Observability means:

```
Mapping high-level commands → low-level system behavior
```

Instead of guessing what happens, I inspect real execution.

---

## 3. Layers of Observation

Different tools expose different layers of the system.

| Tool   | What it shows               |
| ------ | --------------------------- |
| strace | System calls                |
| ps/top | Process and scheduler state |
| lsof   | File descriptor usage       |
| /proc  | Kernel data structures      |
| dmesg  | Kernel and hardware events  |

---

## 4. Observing System Calls using strace

```
strace ls
```

This reveals:

* `open()`
* `read()`
* `write()`
* `close()`

This confirms that commands interact with the kernel only through system calls.

---

## 5. Observing Redirection Internals

```
strace ls > out.txt
```

Observed behavior:

* `open("out.txt")`
* `dup2()`
* `execve("ls")`

This validates that redirection is implemented by modifying file descriptors before execution.

---

## 6. Observing File Descriptors

```
ls /proc/$$/fd
```

This shows the file descriptor table of the current shell process.

Mapping:

* 0 → stdin
* 1 → stdout
* 2 → stderr

These are real kernel-maintained resources.

---

## 7. Observing Process State

```
ps

top
```

These tools expose:

* process hierarchy
* CPU usage
* scheduling state

Most processes are not running; they are waiting.

---

## 8. Observing File Usage

```
lsof
```

This shows:

```
process → file descriptors → files/inodes
```

This reinforces the idea that everything is treated as a file.

---

## 9. Observing Kernel Logs

```
dmesg
```

This exposes:

* hardware interactions
* driver messages
* kernel-level events

---

## 10. Observing Pipelines in Action

```
echo hello | sleep 5
```

Observation:

* Multiple processes run concurrently
* Data flows through kernel-managed pipes

---

## 11. Broken Pipe Behavior

```
yes | head -n 1
```

* `head` exits early
* `yes` receives SIGPIPE
* Kernel terminates the writer

---

## 12. Zombie Processes

A zombie process exists when:

* process has exited
* parent has not yet collected exit status

This directly links to exit code handling.

---

## 13. File Lifetime Behavior

```
rm file
```

* Removes directory entry
* Does not immediately remove data if file is open

File exists as long as:

* link count > 0 OR
* file descriptor is open

---

## 14. Core Mental Model

Observability reveals that:

* commands are processes
* processes interact via file descriptors
* kernel mediates all interactions

---

## 15. Engineering Insight

Debugging in Linux is not about guessing.

It is about:

* inspecting state
* tracing execution
* validating assumptions against real system behavior

---

# Final Synthesis

---

## Execution Flow

```
Shell parses command
→ fork()
→ modify file descriptors (if needed)
→ exec()
→ kernel executes process
→ process exits with status
→ shell retrieves exit code
→ shell decides next action
```

---

## Key Understanding

* Exit codes enable control flow
* File descriptors enable data flow
* Pipes enable inter-process communication
* Observability tools reveal actual system behavior

---

## My Current Understanding

I now see the shell as an orchestration layer that:

* creates processes
* connects them via file descriptors
* observes their completion
* reacts based on exit codes

The kernel performs all actual execution and resource management.

---
