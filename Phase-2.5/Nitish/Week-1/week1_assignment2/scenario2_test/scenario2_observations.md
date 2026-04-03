# Scenario 2: Permission Denied Due to Wrong Ownership

## 1. Objective

To demonstrate that file access can fail due to ownership, even when permissions exist, because the user is placed in a restrictive permission category.

---

## 2. Setup

Created directory:

```
scenario2_test/
└── secret.txt
```

Created file:

```
echo "Top Secret Data" > secret.txt
```

Changed ownership:

```
sudo chown root:root secret.txt
```

---

## 3. Permission Configuration

Set file permissions:

```
sudo chmod 600 secret.txt
```

File state:

```
-rw------- 1 root root ...
```

---

## 4. Observations

### 4.1 File Access Attempt

```
cat secret.txt
```

Output:

```
Permission denied
```

---

### 4.2 Metadata Inspection

```
ls -l secret.txt
```

Output:

```
-rw------- 1 root root ...
```

---

### 4.3 Permission Modification Attempt

```
chmod 600 secret.txt
```

Output:

```
Operation not permitted
```

---

## 5. Core Explanation

Permissions are evaluated based on identity:

* owner
* group
* others

The kernel selects the first matching category and applies only those permissions.

---

## 6. Root Cause

In this scenario:

* File owner = root
* Current user = nitish
* User does not belong to owner or group

So kernel applies:

```
others → ---
```

This results in:

* No read permission
* No write permission
* No execute permission

---

## 7. Key Insight

Even though the file has read and write permissions:

* These permissions belong only to the owner (root)
* They are not available to other users

Access is denied because:

"Permission evaluation depends on ownership before permission bits."

---

## 8. Additional Observation

After changing ownership to root:

* The user can no longer modify file permissions
* Only the owner or root can perform `chmod`

This demonstrates that ownership controls both:

* Access to file contents
* Authority to modify permissions

---

## 9. Conclusion

Ownership determines which permission set applies to a user.

If a user does not match owner or group:

* The "others" category is used
* Even valid permissions in other categories are ignored

This results in access denial despite the presence of permissions.

---
