# Assignment 1: GCC Deep Dive

- Compile a C program with:
  - Debug symbols
  - Warnings
  - Generate object file separately.
  - Link manually.
  - Use ldd to inspect dependencies.
- Explain:
  - What is linked dynamically
  - What is resolved at runtime

---

## Assignment Breakdown

- C → Create C program
- T → Compile with flags and generate object file
- T → Link manually
- O → Observe dependencies using ldd
- D → Differentiate compile vs runtime behavior
- X → Explain dynamic linking

---

## Step-by-Step Execution

### C → Entity Creation (C Program)

```c
cat << EOF > hello.c
#include <stdio.h>

int main() {
    printf("Hello, World\n");
    return 0;
}
EOF
```

---

### T → Compile with Debug Symbols and Warnings (Object File Only)

```bash
gcc -Wall -g -c hello.c -o hello.o
```

---

### T → Manual Linking

```bash
gcc hello.o -o hello
```

---

### O → Run Program

```bash
./hello
```

Expected Output:
```bash
Hello, World
```

---

### O → Inspect Dependencies

```bash
ldd hello
```

Expected Output:
```bash
linux-vdso.so.1
libc.so.6 => /lib/.../libc.so.6
/lib64/ld-linux-x86-64.so.2
```

---

## D → Differentiation

- Compilation produces object file (machine code, not executable)
- Linking combines object files and libraries into executable
- ldd shows shared libraries used at runtime

---

## Explanation

### What is Linked Dynamically

Dynamic linking means that the executable does not contain the full code of libraries like libc. Instead, it stores references to shared libraries that are loaded when the program runs. This reduces binary size and allows shared usage of common libraries.

---

### What is Resolved at Runtime

At runtime, the system loader resolves symbols and links the program to the required shared libraries. Functions like printf are not fully included in the binary but are resolved when the program executes using the dynamic linker.