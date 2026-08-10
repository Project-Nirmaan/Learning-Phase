# Assignment 4: Shell Personalization & Alias Behavior

Task:

- Create 5 useful aliases:
    - One for ls
    - One for navigation
    - One for search
    - One for git (if installed)
    - One custom productivity shortcut
- Make them:
    - Work in current session
    - Persist across terminal restarts
      Verify:
    - `type <alias_name>`
    - `alias`
    - Restart terminal and test again
- Create an alias that breaks something intentionally. Example:

```bash
alias rm='rm -i'
```

- Then override it temporarily using:

```bash
\rm
```

Deliverable:

- Explain why \command bypasses alias
- Explain why aliases don’t work inside non-interactive scripts
- Show difference between alias and function

## Assignment Breakdown

- C → Create aliases
- T → Persist aliases across sessions
- F → Create conflicting/breaking alias
- O → Observe using `type`, `alias`
- D → Compare alias vs `\command` and alias vs function
- V → Verify after terminal restart
- X → Explain alias behavior

---

## Step-by-Step Execution

### C → Create aliases

```
alias ll='ls -la'
alias ..='cd ..'
alias search='grep -rn'
alias gs='git status'
alias cls='clear'
```

---

### O → Observation

```
type ll
alias
````

Expected Output:

```
ll is aliased to `ls -la`
```

---

### T → Persist Aliases

```
echo \"alias ll='ls -la'\" >> ~/.bashrc
echo \"alias ..='cd ..'\" >> ~/.bashrc
echo \"alias search='grep -rn'\" >> ~/.bashrc
echo \"alias gs='git status'\" >> ~/.bashrc
echo \"alias cls='clear'\" >> ~/.bashrc
````

```
source ~/.bashrc
```

---

### V → Verification (After Restart)

```
type ll
```

Expected Output:

```
ll is aliased to `ls -la`
```

---

## Fault Injection

### F → Create Breaking Alias

```
alias rm='rm -i'
```

---

### O → Observation

```
rm testfile.txt
```

Expected Output:

```
rm: remove regular file 'testfile.txt'? 
```

---

### D → Override Alias Temporarily

```
`\rm testfile.txt
```

Expected Output:

```
(file removed without prompt)
```

---

## Differentiation

- Alias expands before command execution
- `\command` bypasses alias expansion
- Alias vs function behavior differs in flexibility

---

## Explanation

### Why `\command` Bypasses Alias

Aliases are expanded by the shell before command execution. When a command is prefixed with a backslash, alias expansion
is skipped, and the shell directly executes the actual binary or built-in command.

---

### Why Aliases Don’t Work in Non-Interactive Scripts

Aliases are only expanded in interactive shells. In non-interactive shells (like scripts), alias expansion is disabled
by default unless explicitly enabled using `shopt -s expand_aliases`. Therefore, scripts do not recognize aliases.

---

### Difference Between Alias and Function

Aliases are simple text substitutions performed before parsing the command. They are limited and cannot accept arguments
reliably.
Functions are more powerful. They can accept arguments, include logic, and behave like reusable commands within the
shell.
Example:

```
alias greet='echo hello'
greet user
```

Expected Output:

```
hello user
```

```
greet() { echo hello $1; }
greet user
```

Expected Output:

```
hello user