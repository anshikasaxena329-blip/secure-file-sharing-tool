#!/bin/bash

# This script is used to generate AGE encryption keys

# It creates a private key and shows the public key for sharing

echo "[+] Setting up AGE keys..."

# First check if age-keygen is installed or not

if ! command -v age-keygen &> /dev/null; then
echo "Error: age-keygen is not installed!"
exit 1
fi

# Check if key already exists so we don't overwrite it

if [ -f "age_key.txt" ]; then
echo "AGE key already exists."
echo "If you want a new key, delete age_key.txt first."
else
# Generate new key
age-keygen -o age_key.txt

```
# Protect the private key (only owner can read/write)
chmod 600 age_key.txt

echo "[✔] Key generated successfully"

# Extract public key from file
PUBKEY=$(grep "public key:" age_key.txt | awk '{print $4}')

echo ""
echo "IMPORTANT:"
echo "- Do NOT share your private key (age_key.txt)"
echo "- Share this public key with sender"
echo ""

echo "Your Public Key:"
echo "$PUBKEY"
```

fi
