#!/bin/bash

# ===============================
# SECURE FILE RECEIVER SCRIPT
# ===============================

# Step 1: take encrypted file input
ENC_FILE=$1

# Step 2: check input
if [ -z "$ENC_FILE" ]; then
    echo " Usage: ./receive.sh file.age"
    exit 1
fi

# check if file exists
if [ ! -f "$ENC_FILE" ]; then
    echo " Encrypted file not found!"
    exit 1
fi

echo " Received file: $ENC_FILE"

# ===============================
# DECRYPT FILE
# ===============================

# remove .age to get original name
OUT_FILE="${ENC_FILE%.age}"

echo " Decrypting file..."

# decrypt using private key
age -d -i ../age_key.txt -o "$OUT_FILE" "$ENC_FILE"

# check decryption
if [ $? -ne 0 ]; then
    echo " Decryption failed (wrong key?)"
    exit 1
fi

echo " Decryption successful"

# ===============================
# VERIFY CHECKSUM
# ===============================

# read original checksum
ORIGINAL_CHECKSUM=$(cat "$OUT_FILE.checksum")

# generate new checksum
NEW_CHECKSUM=$(sha256sum "$OUT_FILE" | awk '{print $1}')

echo " Verifying file..."

if [ "$ORIGINAL_CHECKSUM" == "$NEW_CHECKSUM" ]; then
    echo " File integrity verified"
else
    echo " File corrupted or tampered"
fi
