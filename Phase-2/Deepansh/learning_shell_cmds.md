# 🐧 Linux Commands & Concepts — Complete Notes

## 1️⃣ ssh — Connect to remote server
**Syntax**  
`ssh username@server_ip -p port_number`

**Examples**  
`ssh bandit7@bandit.labs.overthewire.org -p 2220`  
`ssh user@192.168.1.10`  
`ssh user@192.168.1.10 -p 2222`

**Notes**  
- Default port: 22  
- Connect using hostname or IP  
- Used for secure remote login  

---

## 2️⃣ cd — Change directory
`cd folder`          → move into folder  
`cd folder/subfolder`  
`cd ..`               → move up one directory  
`cd ../..`            → move up two directories  
`cd ~`                → go to home  
`cd`                  → home shortcut  
`cd -`                → previous directory  

---

## 3️⃣ ls — List directory contents
`ls`                 → basic listing  
`ls -l`              → long/detailed  
`ls -a`              → include hidden files  
`ls -h`              → human-readable sizes (use with `-l`)  
`ls -R`              → recursive  
`ls -S`              → sort by size  
`ls -t`              → sort by modification time  
`ls -la`             → common combo  
`ls -lh`  
`ls -lah`

**Notes**  
- Options can be combined: `ls -lah`  
- Long vs short options: `-a` vs `--all`  

---

## 4️⃣ pwd — Print working directory
`pwd`  
- Shows absolute path of current directory  

---

## 5️⃣ cat — Concatenate / display files
`cat file.txt`  
`cat file1.txt file2.txt`

**Special filenames**  
`cat ./-file`        → file starting with `-`  
`cat "file name"`    → file with spaces  
`cat ./"- file name"` → spaces + starting with `-`  

**Notes**  
- `./` forces filename interpretation  
- Quotes preserve spaces  
- `--` can also stop option parsing: `cat -- -file`  

---

## 6️⃣ file — Check file type
`file filename`  
`file ./-filename`      → if starts with `-`  
`file -- -filename`     → alternative

- ASCII text → human-readable  
- Binary, image, executable → not human-readable  

**Check all files in a directory**  
`file *`  
`file ./*`            → safer for `-` starting files  
`file /path/to/dir/*`  
`file -r dir_name`    → recursive  

---

## 7️⃣ find — Search for files by metadata
**Basics**  
`find /path -type f`              → regular files only  
`find /path -type d`              → directories only  
`find /path -name "*.txt"`        → filename pattern  
`find /path -size 1033c`          → size in bytes (`c` = bytes)  
`find /path -user username`       → owner  
`find /path -group groupname`     → group owner

**Special**  
`find / -type f -user bandit7 -group bandit6 -size 33c 2>/dev/null`

**Notes**  
- `/` = root directory, entire filesystem  
- `~` = home directory  
- `.` = current directory  
- `..` = parent directory  
- `2>/dev/null` hides permission denied messages  
- Regular file (`-type f`) = normal data files  
- Directory (`-type d`), symlink (`-type l`), pipe, socket, device  

**Run a command on found files**  
`find . -type f -exec grep -H "hello" {} \;`  
- `{}` = placeholder for filename  
- `\;` = end of `-exec`  
- `-print0 | xargs -0 ...` = safer with spaces/newlines  

---

## 8️⃣ grep — Search text inside files
`grep "hello" file.txt`         → search in one file  
`grep -R "hello" dir/`          → recursive  
`grep -Rl "hello" dir/`         → recursive, filenames only  
`grep -Ril "hello" dir/`        → case-insensitive, filenames only

**Notes**  
- `grep` searches content, not metadata  
- Combine with `find` for filtered search  

---

## 9️⃣ uniq — Filter duplicate lines
`uniq file.txt`                → adjacent duplicates removed  
`uniq -u file.txt`             → print only unique lines  
`uniq -d file.txt`             → print only duplicates

**Important**  
- Works only on adjacent duplicate lines  
- Usually combine with `sort` for global uniqueness:  
  `sort file.txt | uniq -u`  
- Alternative using temp file:  
  `sort file.txt > sorted.txt; uniq -u sorted.txt`  

---

## 1️⃣0️⃣ sort — Sort lines
`sort file.txt`                → ascending  
`sort -r file.txt`             → descending  
`sort -n file.txt`             → numeric  
`sort file.txt | uniq -u`      → unique lines globally  

---

## 1️⃣1️⃣ Permissions / Executability
Check file permissions:  
`ls -l file.txt`

| Symbol | Meaning      |
|--------|--------------|
| r      | read         |
| w      | write        |
| x      | execute      |
| -      | no permission|

- Not executable → can safely `cat` or read  
- Executable → may run code  

---

## 1️⃣2️⃣ Ownership
- `-user username` → find by owner  
- `-group groupname` → find by group  
- Files can be owned by other users/groups  
- `chown` is a command, not a `find` predicate  

---

## 1️⃣3️⃣ Redirects & Pipes
- Redirect stdout to file: `> file`  
- Redirect stderr: `2> file`  
- Pipe: `|` → send output of one command to another  

**Example**  
`sort data.txt | uniq -u` → Sort data, then filter unique lines  

- Without `|`, you need temp file or rely on pre-sorted input  

---

## 1️⃣4️⃣ Special file symbols
| Symbol | Meaning       |
|--------|---------------|
| /      | root          |
| ~      | home directory|
| .      | current directory |
| ..     | parent directory |

---

## 1️⃣5️⃣ General Notes & Pro Tips
- Use `--` to stop option parsing for files starting with `-`  
  `cat -- -filename`  
  `file -- -filename`  
- Use `./` to force filename interpretation: `cat ./-file`  
- `uniq` requires sorted input for global uniqueness  
- `find + grep` = powerful search combo  
- `/` searches entire filesystem → may show permission denied errors  
- Always filter by `-type f` when dealing with files to avoid errors
richtext_converted_to_markdown.md
Displaying richtext_converted_to_markdown.md.