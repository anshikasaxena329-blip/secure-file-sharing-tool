#!/bin/bash

# This script is used to send files securely

# It encrypts the file, sends it using SSH, and logs everything

FILE=$1
RECEIVER=$2   # example: user@192.168.1.10
PUBKEY="PASTE_PUBLIC_KEY_HERE"
LOGFILE="transfer.log"

# Check inputs

if [ -z "$FILE" ] || [ -z "$RECEIVER" ]; then
echo "Usage: ./send.sh <file> [user@ip](mailto:user@ip)"
exit 1
fi

# Check file exists

if [ ! -f "$FILE" ]; then
echo "File not found!"
exit 1
fi

# Check age installed

if ! command -v age &> /dev/null; then
echo "age not installed!"
exit 1
fi

echo "[+] File selected: $FILE"

# Generate checksum for integrity check

CHECKSUM=$(sha256sum "$FILE" | awk '{print $1}')
echo "$CHECKSUM" > "$FILE.checksum"

echo "[+] Checksum generated"

# Encrypt file using receiver's public key

ENCRYPTED_FILE="$FILE.age"

echo "[+] Encrypting file..."

if ! age -r "$PUBKEY" -o "$ENCRYPTED_FILE" "$FILE"; then
echo "Encryption failed!"
exit 1
fi

echo "[✔] Encryption successful"

# Send file using SSH (secure transfer)

echo "[+] Sending file via SSH..."

if scp "$ENCRYPTED_FILE" "$FILE.checksum" "$RECEIVER:~/receiver_folder/"; then
echo "[✔] Transfer successful"
STATUS="SUCCESS"
else
echo "Transfer failed!"
STATUS="FAILED (transfer)"
fi

# Logging everything

TIMESTAMP=$(date -Iseconds)

echo "$TIMESTAMP | sender | $RECEIVER | $FILE | sha256:$CHECKSUM | $STATUS" >> "$LOGFILE"

echo "[✔] Logged successfully"

