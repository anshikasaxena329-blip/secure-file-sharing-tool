# Secure File Sharing Tool

## Project Description

This project is about sending files securely using the command line.

The main idea is simple:

* before sending a file, we encrypt it
* only the receiver can decrypt it
* we also check if the file was changed during transfer using checksum

This is useful when we are sending sensitive data like reports, notes, images, etc. so that no one else can read or modify it.



## What this tool does

* encrypts file using **age**
* sends file using **SSH (scp)**
* checks file integrity using **sha256 checksum**
* keeps a record of transfers in a log file



## Setup Instructions

### Step 1: Generate keys

Run:

```bash
./setup_keys.sh
```

This will create:

* `age_key.txt` → this is private, do NOT share
* public key → copy this and use in `send.sh`


### Step 2: Add public key

Open `send.sh`:

```bash
nano send.sh
```

Find:

```bash
PUBKEY="PASTE_YOUR_PUBLIC_KEY_HERE"
```

Paste your public key (starting with `age1...`)



## How to run the system

### Sender side

Create a test file:

```bash
echo "this is a test file" > text.txt
```

Send file:

```bash
./send.sh text.txt localhost
```

or

```bash
./send.sh text.txt user@IP
```

What happens:

* checksum is created
* file is encrypted
* encrypted file is sent
* everything is logged


### Receiver side

Go to receiver folder:

```bash
cd receiver_folder
```

Run:

```bash
../receive.sh text.txt.age
```

What happens:

* file gets decrypted
* checksum is verified
* it tells if file is correct or not


## Output

If everything is correct:

```
Decryption successful
File integrity verified
```

If something is wrong:

```
File corrupted or tampered
```

---

## Log File

All transfers are saved in:

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


## Important Notes

* never share your private key
* always send encrypted file (.age)
* always check checksum
* use only test data (no real sensitive data)


## Limitations

* works only in command line
* supports one receiver at a time
* keys are handled manually


## Possible Improvements

* support multiple receivers
* automatic retry if transfer fails
* better UI (maybe GUI version)
* store config for users and keys


## Conclusion

This project shows a simple way to send files securely.
Even though it is basic, it covers important concepts like encryption, secure transfer, and integrity checking.

It helped me understand how real secure systems work in a simple way.
