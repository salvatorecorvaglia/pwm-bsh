# Password Manager

A simple command-line password manager built with Bash and OpenSSL. This password manager allows you to store and retrieve passwords securely using AES-256 encryption.

## Features

- Store and retrieve passwords for different services.
- Store encrypted passwords in a single file (`passwords.enc`).
- Use a master passphrase for encryption and decryption.
- List stored service names without revealing credentials.
- Secure in-memory handling with temporary decrypted files.
- Robust encryption/decryption logic using a single encrypted block.

## Prerequisites

- Bash shell (typically available on most Unix-based systems).
- `openssl` for encryption and decryption.
  - On Debian-based systems, install it with: `sudo apt install openssl`.

## How to Use

### 1. Download the Script

Download or copy the `password_manager.sh` script to your local machine.

### 2. Make the Script Executable

Before running the script, make sure it has executable permissions:

```bash
chmod +x password_manager.sh
```

### 3. Run the Script

Run the script using:

```bash
./password_manager.sh
```
