# Secure File Sharing Tool

## Project Description

This project implements a simple secure file sharing system using the command line. The goal is to safely transfer files between users so that:

- only the intended receiver can read the file  
- the file is not modified during transfer  
- the process is simple and reliable  

This is useful when sharing sensitive data like reports, notes, or images where security and integrity are important.

---

## System Overview

The system works in the following steps:

1. The sender selects a file  
2. A checksum (sha256) is generated for the file  
3. The file is encrypted using the receiver’s public key (age)  
4. The encrypted file is transferred using SSH (scp)  
5. The receiver decrypts the file using their private key  
6. The checksum is verified to ensure the file was not altered  
7. The transfer is recorded in a log file  

---

## Tools Used

- age → used for file encryption and decryption  
- scp (SSH) → used for secure file transfer  
- sha256sum → used for generating and verifying checksums  
- bash scripting → used to automate the workflow  

These tools were chosen because they are simple, secure, and available on most Linux systems.

---

## Project Structure

secure-share/
├── send.sh  
├── receive.sh  
├── setup_keys.sh  
├── transfer.log  
├── README.md  

---

## Setup Instructions

### 1. Generate Encryption Keys

Run:

```
./setup_keys.sh
```

This script:
- generates a private key (age_key.txt)  
- generates a public key  
- prints the public key  

The private key must be kept secret. The public key is shared with the sender.

---

### 2. Configure Public Key in Sender

Open the sender script:

```
nano send.sh
```

Find this line:

```
PUBKEY="PASTE_YOUR_PUBLIC_KEY_HERE"
```

Replace it with the public key generated from setup_keys.sh.

---

### 3. Setup SSH Access

To enable secure transfer, SSH key-based login must be configured:

```
ssh-keygen -t ed25519
cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys
```

Test:

```
ssh localhost
```

---

## How the Code Works

### setup_keys.sh

- Generates keys using age-keygen  
- Stores private key in age_key.txt  
- Prints public key  
- Ensures private key is kept secret  

---

### send.sh

This script performs sender operations:

1. Checks if the file exists  
2. Generates checksum using:
```
sha256sum file.txt
```

3. Encrypts file:
```
age -r PUBLIC_KEY -o file.txt.age file.txt
```

4. Transfers files:
```
scp file.txt.age user@host:
scp file.txt.checksum user@host:
```

5. Logs the transfer in transfer.log  

---

### receive.sh

This script performs receiver operations:

1. Checks if encrypted file exists  
2. Decrypts file:
```
age -d -i age_key.txt -o file.txt file.txt.age
```

3. Generates new checksum:
```
sha256sum file.txt
```

4. Compares checksum with original  

5. Displays result:
- match → file is correct  
- mismatch → file is corrupted  

6. Logs result in transfer.log  

---

## Running the System

### Sender Side

Create a file:

```
echo "this is a test file" > text.txt
```

Send file:

```
./send.sh text.txt localhost
```

---

### Receiver Side

Run:

```
./receive.sh text.txt.age
```

---

## Example Output

Successful case:

```
Decryption successful
File integrity verified
```

Failure case:

```
Decryption failed
File corrupted
```

---

## Logging

All transfers are recorded in:

```
transfer.log
```

Format:

```
TIMESTAMP | SENDER | RECEIVER | FILENAME | CHECKSUM | STATUS
```

Example:

```
2026-05-01T10:30:11 | sender | localhost | text.txt | sha256:abc123 | SUCCESS
```

---

## Error Handling

The scripts handle:

- file not found  
- missing keys  
- encryption failure  
- transfer failure  
- checksum mismatch  

Errors are shown clearly to the user.

---

