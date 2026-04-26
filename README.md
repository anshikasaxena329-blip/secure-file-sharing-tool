# Secure File Sharing Tool

## Project Description

In this project, a simple command-line tool used to send files securely.
The main idea is to encrypt the file before sending so that only the receiver can read it.

The checksumis used to check if the file gets changed during transfer.
All the file transfers are saved in a log file.

This project can be useful when we want to send important or private data safely.

---

## Setup Instructions

### Step 1: Generate Keys

Run this command:

./setup_keys.sh

This will create:
- a private key (age_key.txt), keep it safe
- a public key, copy this

---

### Step 2: Add Public Key

Open send.sh and paste your public key:

PUBKEY="your_public_key_here"

Make sure:
- copy only the part starting with "age1"
- don’t add extra text

---

## How to Run

### Sender Side

Step 1: Create a file

echo "Hello secure world" > notes.txt

Step 2: Send the file

./send.sh notes.txt

This will:
- create checksum
- encrypt the file
- send it to receiver_folder
- save details in log file

---

### Receiver Side

Step 1: Go to folder

cd receiver_folder

Step 2: Receive file

../receive.sh notes.txt.age

This will:
- decrypt the file
- check checksum
- show result

---

## Output

If correct:

Decryption successful
File integrity verified

If error:

File corrupted or tampered

---

## Notes

- Do not share private key
- Always send encrypted file (.age)
- Always check checksum
- Use test files only

---

## Log File

All transfers are saved in transfer.log like this:

2026-04-26T10:30:11 | sender | receiver | notes.txt | sha256:abc123 | SUCCESS

