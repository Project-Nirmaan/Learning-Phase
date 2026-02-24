Permission Debugging Drill — Assignment

In this assignment, I learned how Linux file and directory permissions work and how to fix "Permission denied" errors.

First, I created a directory and a file. Then I removed execute permission from the directory using the chmod -x command. This caused a "Permission denied" error when trying to enter the directory. I fixed it using chmod +x, which restored access.

Next, I removed read permission from the file using chmod -r. This prevented me from reading the file. I fixed it by giving read permission back using chmod +r.

Finally, I restored proper file permissions using chmod 644 and verified them using ls -l.

This assignment taught me:

How Linux permissions control file and directory access

Meaning of read (r), write (w), and execute (x) permissions

How to debug permission errors

How to use the chmod command to fix access issues

How to safely manage permissions without using sudo

This improved my understanding of Linux security and permission management.
