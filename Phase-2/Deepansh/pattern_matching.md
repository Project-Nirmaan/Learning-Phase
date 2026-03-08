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

These alone solve **most bash/grep/sed regex problems**.
