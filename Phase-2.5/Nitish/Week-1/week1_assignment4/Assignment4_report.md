# Assignment 4 Report

## Shell Personalization & Alias Behavior

**Phase 2.5 — The Shell Wizard**

---

# 1. Objective

The goal of this assignment was not just to learn shell aliases, but to deeply understand:

* How the shell interprets commands
* Where alias fits in the execution pipeline
* The boundary between **shell behavior (user-space)** and **kernel execution**
* The limitations, risks, and real-world implications of shell customization

This assignment focuses on building a **first-principles mental model** through experimentation, failure analysis, and validation.

---

# 2. Mental Model of the Shell

The shell is not merely a command-line interface. It is a **language interpreter** that translates human-readable commands into executable actions.

### Execution Pipeline

```text
User Input
↓
Tokenization
↓
Alias Expansion
↓
Parsing
↓
Command Resolution
↓
fork()
↓
execve()
↓
Kernel Execution
```

---

### Key Insight

* Shell operates in **user space**
* Kernel executes **final resolved commands**
* Alias exists **before execution**, entirely inside the shell

---

# 3. What is an Alias?

### Definition

An alias is a **shell-level text substitution mechanism** that replaces a command token with predefined text before execution.

### Example

```bash
alias l1='echo Hello_ALIAS'
l1
```

Output:

```text
Hello_ALIAS
```

---

### Core Properties

| Property          | Behavior                 |
| ----------------- | ------------------------ |
| Nature            | Text substitution        |
| Scope             | Shell-local              |
| Execution         | No independent execution |
| Kernel visibility | None                     |
| Argument handling | No                       |

---

### Key Insight

> Alias modifies **input text**, not execution behavior.

---

# 4. Experimentation & Observations

---

## Experiment 1 — Basic Alias Behavior

```bash
alias l1='echo Hello_ALIAS'
l1
type l1
```

### Output

```text
Hello_ALIAS
l1 is aliased to `echo Hello_ALIAS`
```

### Observation

* Alias correctly substitutes command
* Shell internally stores alias mapping

### Concept

Alias = **symbol → text mapping inside shell**

---

## Experiment 2 — First Token Rule

```bash
alias testcmd='echo FIRST'
echo testcmd
```

### Output

```text
testcmd
```

### Observation

* Alias not applied inside arguments

### Concept

> Alias applies only to **first token of command**

---

## Experiment 3 — Alias vs strace (Failure Case)

```bash
alias l1='ls -l'
strace l1
```

### Output

```text
strace: Cannot find executable 'l1'
```

### Observation

* Alias not expanded when used as argument

### Explanation

Shell sees:

```text
["strace", "l1"]
```

Only first token (`strace`) is checked for alias.

### Concept

> Alias expansion is **non-recursive and position-dependent**

---

## Experiment 4 — Alias in Script (Failure)

```bash
#!/bin/bash
alias l1='echo FAIL'
l1
```

### Output

```text
command not found
```

### Observation

* Alias does not work in scripts

### Explanation

Non-interactive shell disables alias expansion.

### Concept

> Alias is designed for **interactive use only**

---

## Experiment 5 — Alias and Arguments

```bash
alias greet='echo Hello'
greet Abhi
```

### Output

```text
Hello Abhi
```

---

```bash
alias greet='echo Hello $1'
greet Abhi
```

### Output

```text
Hello Abhi
```

### Observation

* Appears like argument passing works

### Deeper Analysis

Alias expands to:

```bash
echo Hello $1 Abhi
```

`$1` is interpreted by shell, not alias.

### Concept

> Alias has **no argument binding mechanism**

---

## Experiment 6 — Syntax Breaking (Critical Insight)

```bash
alias greet='echo Hello $1'
greet() { echo Hello $1; }
```

### Output

```text
syntax error near unexpected token '('
```

### Root Cause

Alias expansion happens before parsing:

```bash
echo Hello $1() { ... }
```

Invalid syntax.

### Concept

> Alias operates at **lexical level**, not syntactic level

---

## Experiment 7 — Alias Override

```bash
alias ls='echo Hacked'
ls
\ls
```

### Output

```text
Hacked
(actual directory listing with \ls)
```

### Observation

* Alias overrides real command
* `\` bypasses alias

### Concept

> Shell resolution order prioritizes alias

---

## Experiment 8 — Subshell Behavior

```bash
alias mycmd='echo INSIDE_SHELL'
bash -c 'mycmd'
```

### Output

```text
command not found
```

### Observation

* Alias not available in new shell

### Concept

> Alias is **process-local state**

---

## Experiment 9 — Persistence

```bash
# added to ~/.bashrc
alias testpersist='echo WORKS'
source ~/.bashrc
testpersist
```

### Output

```text
WORKS
```

### Concept

> Shell environment is built from startup files

---

## Experiment 10 — Command Type Resolution

```bash
type ls
type cd
type echo
```

### Output

```text
ls is aliased to `ls --color=auto`
cd is a shell builtin
echo is a shell builtin
```

### Concept

Command resolution hierarchy:

```text
Alias → Function → Built-in → Binary
```

---

# 5. Alias vs Function

| Feature     | Alias             | Function         |
| ----------- | ----------------- | ---------------- |
| Type        | Text substitution | Executable logic |
| Arguments   | No                | Yes              |
| Scope       | Limited           | Flexible         |
| Parsing     | Before parsing    | After parsing    |
| Reliability | Low               | High             |

---

### Key Insight

> Alias = convenience
> Function = programmable abstraction

---

# 6. Connection to OS Internals

From system execution model:

* Shell → user space
* Kernel → execution authority

### Execution Flow

```text
Shell expands alias
↓
fork()
↓
execve()
↓
Kernel executes binary
```

---

### Key Insight

> Kernel never sees alias — only final command

---

# 7. Critical Learnings

---

## 7.1 Alias is Lexical, Not Logical

* No syntax awareness
* No validation
* Blind substitution

---

## 7.2 Alias is Context-Sensitive

* Only first token
* Only interactive shell

---

## 7.3 Alias is Non-Portable

* Not inherited across processes
* Not reliable in scripts

---

## 7.4 Alias Can Break Code

* Can corrupt valid syntax
* Can override critical commands

---

## 7.5 Alias Exists Only in Shell Memory

* Not part of kernel
* Not environment variable

---

# 8. Misconceptions Corrected

| Misconception                 | Reality |
| ----------------------------- | ------- |
| Alias is like function        | False   |
| Alias supports arguments      | False   |
| Alias works everywhere        | False   |
| Alias affects kernel behavior | False   |

---

# 9. Final Insights

---

### Insight 1

> Shell is a **multi-stage interpreter**, not just command executor.

---

### Insight 2

> Alias is a **pre-processing layer**, similar to macros in programming languages.

---

### Insight 3

> The boundary between shell and kernel is strict:

* Shell decides *what to run*
* Kernel decides *how to run*

---

### Insight 4

> Reliability requires:

* Avoid alias in scripts
* Prefer functions or explicit commands

---

### Insight 5

> Failures revealed deeper truths than successful runs.

---

# 10. Conclusion

This assignment transformed the understanding of shell from:

> “A tool to run commands”

to:

> “A programmable interpreter that transforms user input before interacting with the kernel”

Alias, though simple, exposed:

* execution pipeline structure
* parsing vs execution distinction
* process-level isolation
* limitations of syntactic abstraction

This understanding is foundational for:

* debugging shell behavior
* writing reliable scripts
* understanding OS-level execution flow

---

# Finally we conclude

> Alias is not a feature.
> It is an entry point into understanding how **user-space abstractions shape system execution**.
