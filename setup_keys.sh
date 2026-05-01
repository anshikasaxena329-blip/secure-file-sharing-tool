#!/bin/bash

# This script is used to generate AGE encryption keys
# It creates a private key and shows the public key for sharing

echo "[+] Setting up AGE keys..."

# Check if age-keygen is installed
if ! command -v age-keygen > /dev/null 2>&1; then
    echo "Error: age-keygen is not installed!"
    exit 1
fi

# Check if key already exists
if [ -f "age_key.txt" ]; then
    echo "AGE key already exists."
    echo "If you want a new key, delete age_key.txt first."
else
    # Generate new key
    age-keygen -o age_key.txt

    # Protect private key (important for security)
    chmod 600 age_key.txt

    echo "[+] Key generated successfully"

    # Extract public key from file (clean output)
    PUBKEY=$(grep "public key:" age_key.txt | awk '{print $4}')

    echo ""
    echo "IMPORTANT:"
    echo "- Keep your private key (age_key.txt) secret"
    echo "- Share this public key with sender"
    echo ""

    echo "Public key:"
    echo "$PUBKEY"
fi
