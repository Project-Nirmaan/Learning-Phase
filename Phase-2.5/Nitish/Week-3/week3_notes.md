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
