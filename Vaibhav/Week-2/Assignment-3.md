# Assignment 3: PATH Hijack Experiment

- Create a fake command in a custom directory.
- Modify PATH.
- Override system command behavior.
- Explain why this is dangerous.

---

## Assignment Breakdown

- E → Create custom directory
- C → Create fake command
- T → Modify PATH
- F → Override system command
- O → Observe command resolution
- D → Compare before vs after PATH change
- X → Explain security implications

---

## Step-by-Step Execution

### E → Create custom directory

```bash
mkdir -p ~/fakebin
cd ~/fakebin
```

---

### C → Create fake command

```bash
echo -e '#!/bin/bash\necho FAKE LS EXECUTED' > ls
chmod +x ls
```

---

### O → Observation (Before PATH Change)

```bash
which ls
```

Expected Output:

```bash
/bin/ls
```

---

### T → Modify PATH

```bash
export PATH=~/fakebin:$PATH
```

---

### O → Observation (After PATH Change)

```bash
which ls
```

Expected Output:

```bash
/home/user/fakebin/ls
```

---

### F → Override System Command

```bash
ls
```

Expected Output:

```bash
FAKE LS EXECUTED
```

---

### D → Differentiation

- Before PATH change → system binary used
- After PATH change → fake command takes precedence
- Shell searches directories in PATH from left to right

---

## Explanation

### Why This is Dangerous

The shell resolves commands by searching directories listed in PATH in order. If a malicious or unintended directory is
placed before system directories, it can override legitimate system commands.

This can lead to execution of harmful scripts instead of trusted binaries. For example, a fake ls, rm, or sudo could log
sensitive data, delete files, or alter system behavior without the user realizing it.

This is especially dangerous in multi-user systems or scripts where PATH is not carefully controlled, as it can
introduce security vulnerabilities and unpredictable behavior.