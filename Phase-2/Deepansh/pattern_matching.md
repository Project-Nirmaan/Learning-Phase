# Regex Basics (Quick Guide)

## 1. What is Regex?

Regex (Regular Expression) is a **pattern used to match text**.

Example text:

```
France Paris Japan Tokyo
```

Regex:

```
France
```

Match:

```
France
```

---

# 2. Character Matching

| Regex   | Meaning           | Example Match |
| ------- | ----------------- | ------------- |
| `.`     | any character     | `a`, `7`, `@` |
| `[abc]` | a OR b OR c       | `a`           |
| `[0-9]` | any digit         | `5`           |
| `[a-z]` | lowercase letters | `k`           |

Example:

```
[0-9]
```

Matches digits in:

```
a1 b4 c7
```

Result:

```
1 4 7
```

---

# 3. Repetition Operators

| Regex | Meaning   |
| ----- | --------- |
| `*`   | 0 or more |
| `+`   | 1 or more |
| `?`   | optional  |

Example text:

```
aaa
```

Regex:

```
a+
```

Match:

```
aaa
```

---

# 4. The Important Pattern: `[^<]*`

Breakdown:

```
[^<]
```

Means:

```
any character EXCEPT <
```

Then:

```
[^<]*
```

Means:

```
any characters until we see <
```

Example:

```
France</span>
```

Regex:

```
[^<]*
```

Match:

```
France
```

---

# 5. Capturing Groups `( )`

Parentheses **capture parts of a match**.

Example text:

```
Country: France Capital: Paris
```

Regex:

```
Country: (.*) Capital: (.*)
```

Captured:

```
\1 → France
\2 → Paris
```

---

# 6. Example From HTML Extraction

HTML:

```
country-name">France</span>
```

Regex:

```
country-name">([^<]*)
```

Breakdown:

| Part             | Meaning              |
| ---------------- | -------------------- |
| `country-name">` | match literal text   |
| `(`              | start capture        |
| `[^<]*`          | everything until `<` |
| `)`              | end capture          |

Captured result:

```
France
```

---

# 7. Applying It To The Assignment

HTML line:

```
<li>Country: <span class="country-name">France</span>, Capital: <span class="country-capital">Paris</span></li>
```

Regex idea:

```
country-name">([^<]*)
country-capital">([^<]*)
```

Captured output:

```
France
Paris
```

---

# 8. Mental Trick For HTML Regex

Whenever you see:

```
">TEXT</
```

Use:

```
[^<]*
```

Meaning:

```
everything until the next HTML tag
```

---

# 9. The 5 Regex Things To Memorize

```
.      any character
*      0 or more
+      1 or more
[^x]   anything except x
(...)  capture group
```

# GREP + REGEX Complete Quick Guide (IITM System Commands)

---

# 1. What is grep

grep searches **text patterns inside files**.

Basic syntax:

```
grep pattern file
```

Example

File `data.txt`

```
apple
banana
mango
```

Command

```
grep apple data.txt
```

Output

```
apple
```

---

# 2. Case-Insensitive Search

Option

```
-i
```

Example

```
grep -i apple file.txt
```

Matches

```
apple
Apple
APPLE
```

---

# 3. Whole Word Matching

Option

```
-w
```

Example

```
grep -w cat file.txt
```

Matches

```
cat
```

But NOT

```
catalog
scatter
```

---

# 4. Count Matches

Option

```
-c
```

Example

```
grep -c apple file.txt
```

Output

```
3
```

---

# 5. Show Line Numbers

Option

```
-n
```

Example

```
grep -n apple file.txt
```

Output

```
3:apple
7:apple
```

---

# 6. Invert Match (NOT Matching)

Option

```
-v
```

Example

```
grep -v apple file.txt
```

Shows all lines **except apple**.

---

# 7. Recursive Search (Multiple Files)

Option

```
-r
```

Example

```
grep -r "error" .
```

Searches **all files in current directory**.

---

# 8. Search Multiple Files

Example

```
grep apple file1.txt file2.txt
```

Output

```
file1.txt: apple
file2.txt: apple
```

---

# 9. Search Multiple Words

Use

```
-E
```

Example

```
grep -E "cat|dog" file.txt
```

Matches

```
cat
dog
```

---

# 10. Using egrep

`egrep` is equivalent to

```
grep -E
```

Example

```
egrep "cat|dog" file.txt
```

---

# Important Regex Concepts

---

# Any Character

```
.
```

Example

```
c.t
```

Matches

```
cat
cot
cut
```

---

# Digits

```
[0-9]
```

Example

```
grep "[0-9]" file.txt
```

Matches lines containing digits.

---

# Letters

```
[a-z]
```

Matches lowercase letters.

---

# NOT Character

```
[^a]
```

Meaning

```
any character except a
```

---

# Anchors

Start of line

```
^ 
Note if we write ^ inside brackets it acts as not or "!" in prog langs otherwise its startswith
```

Example

```
^cat
```

Matches

```
cat runs fast
```

Not

```
my cat runs
```

---

End of line

```
$
```

Example

```
cat$
```

Matches

```
I love cat
```

---

# Repetition

```
*  → 0 or more
+  → 1 or more
?  → optional
```

Example

```
a+
```

Matches

```
a
aa
aaa
```

---

# Exact Count

```
{n}

we can also have range count as in {a,b} that means it accepts occurences no.of times between a and b
```

Example

```
[0-9]{3}
```

Matches

```
123
456
789
```

---

# Common Exam Regex Patterns

---

## Exactly 3 letters

```
^[a-zA-Z]{3}$
```

Matches

```
cat
dog
sun
```

---

## Exactly 2 digits

```
[0-9]{2}
```

Matches

```
45
12
90
```

---

# Lines Ending With 2 Digits

Regex

```
[0-9]{2}$
```

Matches

```
hello45
test99
abc12
```

---

# Lines Starting With 3 Letters Followed By 2 Digits

Regex

```
^[a-zA-Z]{3}[0-9]{2}
```

Matches

```
abc12
dog34
cat99
```

---

# Lines Starting With Digit

Regex

```
^[0-9]
```

Example matches

```
5hello
2test
9abc
```

---

# Lines Ending With Letter

Regex

```
[a-zA-Z]$
```

Matches

```
helloA
testb
worldZ
```

---

# Find Words From Another File

File `words.txt`

```
cat
dog
```

File `data.txt`

```
cat runs
dog sleeps
bird flies
```

Command

```
grep -f words.txt data.txt
```

Output

```
cat runs
dog sleeps
```

---

# Searching Recursively In Folder

Command

```
grep -r "error" .
```

Searches **all files in current directory and subfolders**.

---

# Searching Multiple Words

Command

```
grep -E "apple|banana|mango" file.txt
```

Matches lines containing any of the words.

---

# Important grep Commands To Memorize

```
grep word file
grep -i word file
grep -w word file
grep -n word file
grep -c word file
grep -v word file
grep -r word directory
grep -E "word1|word2" file
grep "[0-9]" file
grep "^word" file
```

---

# Regex Cheat Sheet

```
^ start of line
$ end of line
. any character
* 0 or more
+ 1 or more
? optional
[abc] a OR b OR c
[a-z] letters
[0-9] digits
[^x] not x
() capture group
{n} exact number
```

---

# Quick Mental Trick For Regex

If you want

**start of line**

```
^
```

If you want

**end of line**

```
$
```

If you want

**letters**

```
[a-zA-Z]
```

If you want

**digits**

```
[0-9]
```

---

# Example Exam Style Problems

Problem
Lines starting with **3 letters followed by 2 digits**

Regex

```
^[a-zA-Z]{3}[0-9]{2}
```

---

Problem
Lines ending with **2 digits**

Regex

```
[0-9]{2}$
```

---

Problem
Lines containing **at least one digit**

Regex

```
[0-9]
```

---

Problem
Lines starting with **digit**

Regex

```
^[0-9]
```

---

# Final 5 Regex Things To Memorize

```
.      any character
*      0 or more
+      1 or more
[^x]   anything except x
(...)  capture group
```

These alone solve **most grep / bash regex questions**.

