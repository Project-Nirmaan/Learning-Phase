Safe Backup Workflow — Assignment

In this assignment, I learned how to safely create a manual backup of a directory in Linux using archiving, compression, timestamp, and verification.

First, I created a directory containing sample files and checked its original size using the du -sh command.

Then, I archived the directory using the tar -cvf command, which combined all files into a single archive file.

Next, I compressed the archive using the gzip command to reduce its size and improve storage efficiency.

After that, I created a timestamped backup file using the cp command with the date function. This helps in identifying backups and prevents overwriting previous backups.

Finally, I verified the backup size using du -sh and confirmed backup integrity using tar -tvf, which showed all files inside the backup.

This assignment taught me:

How to archive directories using tar

How to compress backups using gzip

How to create timestamped backups

How to verify backup size and integrity

Importance of safe backup workflow in Linux

This improved my understanding of Linux backup management and data safety.
