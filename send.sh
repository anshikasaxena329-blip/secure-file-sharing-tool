#!/bin/bash

# This script is used to send files securely
# It takes a file, encrypts it using age, sends it either locally or via SSH,
# and logs the full transfer details

# Input arguments
FILE=$1
RECEIVER=$2   # example: user@IP or localhost

# Paste the public key generated from setup_keys.sh
PUBKEY="age15k737r86x6ykadc2g93tr42wtru88rt0q4getj4e57rg66dagdfq6e2jhq"

# Log file name
LOGFILE="transfer.log"

# ===============================
# CHECK INPUT
# ===============================

# Check if file and receiver are provided
if [ -z "$FILE" ] || [ -z "$RECEIVER" ]; then
    echo "Usage: ./send.sh <file> <user@ip OR localhost>"
    exit 1
fi

# Check if file exists
if [ ! -f "$FILE" ]; then
    echo "Error: File not found"
    exit 1
fi

# Check if age is installed
if ! command -v age > /dev/null 2>&1; then
    echo "Error: age is not installed"
    exit 1
fi

echo "File selected: $FILE"

# ===============================
# GENERATE CHECKSUM
# ===============================

# Create checksum of original file
CHECKSUM=$(sha256sum "$FILE" | awk '{print $1}')
echo "$CHECKSUM" > "$FILE.checksum"

echo "Checksum generated"

# ===============================
# ENCRYPT FILE
# ===============================

ENCRYPTED_FILE="$FILE.age"

echo "Encrypting file..."

# Encrypt using public key
if ! age -r "$PUBKEY" -o "$ENCRYPTED_FILE" "$FILE"; then
    echo "Encryption failed"
    exit 1
fi

echo "Encryption successful"

# ===============================
# TRANSFER FILE
# ===============================

echo "Transferring file..."

# If sending to same machine
if [ "$RECEIVER" == "localhost" ]; then
    echo "Using local transfer"

    # Create receiver folder if not exists
    mkdir -p receiver_folder

    # Copy files locally
    cp "$ENCRYPTED_FILE" receiver_folder/
    cp "$FILE.checksum" receiver_folder/

    STATUS="SUCCESS"

else
    echo "Sending via SSH..."

    # Send files via scp
    if scp "$ENCRYPTED_FILE" "$FILE.checksum" "$RECEIVER:~/receiver_folder/"; then
        STATUS="SUCCESS"
    else
        echo "Transfer failed"
        STATUS="FAILED (transfer)"
    fi
fi

# ===============================
# LOGGING
# ===============================

TIMESTAMP=$(date +"%Y-%m-%dT%H:%M:%S")

echo "$TIMESTAMP | sender | $RECEIVER | $FILE | sha256:$CHECKSUM | $STATUS" >> "$LOGFILE"

echo "Logged successfully"
