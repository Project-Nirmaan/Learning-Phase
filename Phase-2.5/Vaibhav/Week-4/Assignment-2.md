# Assignment 2: Network Debugging Drill

Using `curl`, `netstat` / `ss`, `ping`, Diagnose:
- Whether a port is open 
- Whether a service is reachable 
- Whether DNS resolves

---

## Assignment Breakdown

- C → Generate network requests
- O → Observe using curl, ss/netstat, ping
- D → Differentiate connectivity states
- V → Verify service and port status
- X → Explain networking checks

---

## Step-by-Step Execution

### C → Check DNS Resolution (ping)

```bash
ping -c 3 google.com
```

Expected Output:
```bash
PING google.com (142.x.x.x): 56 data bytes
64 bytes from 142.x.x.x: icmp_seq=1 ttl=...
```

---

### O → Check Service Reachability (curl)

```bash
curl -I https://google.com
```

Expected Output:
```bash
HTTP/1.1 200 OK
```

---

### O → Check Open Ports (ss)

```bash
ss -tuln
```

Expected Output:
```bash
LISTEN 0 128 0.0.0.0:22
LISTEN 0 128 127.0.0.1:631
```

---

### V → Check Specific Port

```bash
ss -tuln | grep :22
```

Expected Output:
```bash
LISTEN 0 128 0.0.0.0:22
```

---

## D → Differentiation

- ping verifies DNS resolution and basic connectivity
- curl verifies application-layer service availability
- ss/netstat verifies open ports and listening services

---

## Explanation

### DNS Resolution

When you run ping with a domain name, the system first resolves it to an IP address using DNS. If this fails, the domain cannot be reached by name.

---

### Service Reachability

curl sends an HTTP request to the server. A valid response indicates that the service is running and accessible over the network.

---

### Port Availability

Tools like ss or netstat show which ports are open and listening on the system. If a port is not listed, no service is actively listening on it.

---

### Combined Diagnosis

Using these tools together helps identify where a problem lies:
- If DNS fails → name resolution issue
- If ping fails → network connectivity issue
- If curl fails → service may be down
- If port not open → service not listening