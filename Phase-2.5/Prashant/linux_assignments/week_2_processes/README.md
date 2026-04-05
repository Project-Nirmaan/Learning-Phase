# Week 2 - Process Monitoring and Signals

## Why This Matters
In real systems, you must inspect running processes and control them safely.

Hinglish mindset:
- `ps` is like attendance sheet: kaun chal raha hai, kaun nahi.
- `top` is live CCTV: real-time CPU/memory behavior.
- `lsof` is file detective: process ne kaunsi files/sockets open ki hui hain.

If your app hangs or server gets slow, these tools help you debug fast.

## Important Commands
```bash
# Snapshot of processes
ps -ef

# Interactive real-time process monitor
top

# Which process opened which file/socket
lsof -i
lsof /var/log/syslog
```

## SIGINT vs SIGKILL
- `SIGINT` (`kill -SIGINT <pid>`): polite stop request. Program can handle/cleanup.
- `SIGKILL` (`kill -SIGKILL <pid>`): force stop. No cleanup chance.

## Demo Script
```bash
chmod +x process_signals_demo.sh
./process_signals_demo.sh
```

## Quick Why Example
If your process writes to a file/database, SIGINT gives it a chance to close resources cleanly.
SIGKILL is emergency brake: useful when process is stuck and not responding.
