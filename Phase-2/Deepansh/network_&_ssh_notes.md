# Networking, HTTP, and SSH — Conceptual Notes

## 1. Client–Server Model
- A **server** is a computer that stays online and provides data or services.
- A **client** is a computer or program that requests data or services.
- Communication happens over networks using defined rules called **protocols**.

General flow:
~~~text
Client → Router/WiFi → Internet → Server
~~~

---

## 2. IP Address
- An **IP address** uniquely identifies a machine on a network.
- Used to locate *which machine* data should be sent to.
- Machines may have:
  - Private IP (inside a local network)
  - Public IP (visible on the internet)

---

## 3. Ports
- A **port** identifies *which service/program* on a machine should handle the request.
- Multiple services can run on the same server using different ports.

Analogy:
- Server = house
- IP = house address
- Port = room number
- Service = person in the room

Common ports:
- 80 → HTTP
- 443 → HTTPS
- 22 → SSH

---

## 4. Protocol Stack (Simplified)
- **IP** → finds the machine
- **TCP** → reliable data transfer
- **HTTP / SSH** → define how communication works

---

## 5. HTTP (Web Communication)
- HTTP is used to request and send web-related data.
- Browser acts as the client.
- Web server responds with HTML, CSS, JS, or JSON.
- HTTP runs on top of TCP.
- HTTPS is HTTP with encryption.

Purpose:
- Websites
- APIs
- User-facing data access

---

## 6. SSH (Secure Shell)
- SSH is used to securely log into and control a remote machine.
- Provides an encrypted terminal session.
- Used for administration, development, and automation.
- Runs on port 22.

Purpose:
- Remote login
- Running commands
- Managing files and services

---

## 7. SSH Authentication
- Servers restrict access using system users.
- Authentication methods include:
  - Username + password
  - SSH key-based authentication (preferred)

---

## 8. SSH Keys (Asymmetric Cryptography)
- SSH uses a **key pair**:
  - Private key → stays on the client, must be kept secret
  - Public key → stored on the server

Concept:
- Public key acts like a lock.
- Private key acts like the key that opens the lock.

---

## 9. SSH Key Generation
- A key pair is generated on the client machine.
- Keys are stored as files.
- File names are only storage labels and do not define meaning.

Example:
~~~text
private key  → id_ed25519
public key   → id_ed25519.pub
~~~

---

## 10. SSH Key-Based Login Flow
1. Client requests SSH connection.
2. Server checks if it has the client’s public key.
3. Server sends a challenge.
4. Client proves ownership using the private key.
5. Server verifies using the public key.
6. Encrypted session is established.

Important:
- Private key is never sent over the network.
- Authentication is done by proof, not by sharing secrets.

---

## 11. SSH vs HTTP (High-Level)
- SSH gives full control of a machine.
- HTTP provides controlled access to data or endpoints.
- SSH is for admins/developers.
- HTTP is for browsers and applications.

---

## 12. SSH Command Usage

### Basic SSH Login (Password-based)
~~~text
ssh username@server_ip
~~~
- Prompts for the user’s password.
- Authentication is done using username + password.

---

### SSH Login Using a Specific Port
~~~text
ssh -p 2222 username@server_ip
~~~
- Used when the SSH service is running on a non-default port.

---

### SSH Login Using Key-Based Authentication
~~~text
ssh -i /path/to/private_key username@server_ip
~~~
- Uses the specified private key for authentication.
- No password is required if the key is accepted by the server.

---

### Default Key-Based SSH Login
~~~text
ssh username@server_ip
~~~
- SSH automatically looks for private keys in:
~~~text
~/.ssh/
~~~
- Common default key names:
~~~text
id_rsa
id_ed25519
~~~

---

### Copy Public Key to Server
~~~text
ssh-copy-id username@server_ip
~~~
- Adds the client’s public key to the server’s authorized keys list.

---

### SSH Configuration File Usage
~~~text
~/.ssh/config
~~~

Example configuration:
~~~text
Host myserver
    HostName 192.168.1.10
    User ubuntu
    IdentityFile ~/.ssh/id_ed25519
~~~

Usage:
~~~text
ssh myserver
~~~

---

### Executing a Single Command Over SSH
~~~text
ssh username@server_ip "ls -la"
~~~
- Runs a command on the remote server and exits.

---

### Secure File Copy Using SSH
~~~text
scp localfile username@server_ip:/remote/path
~~~
~~~text
scp username@server_ip:/remote/file localpath
~~~

---

### SSH Session Exit
~~~text
exit
~~~
or
~~~text
Ctrl + D
~~~

