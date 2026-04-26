#!/bin/bash

# ===============================
# This script creates AGE keys
# ===============================

echo " Setting up AGE keys..."

# check if key already exists
if [ -f "age_key.txt" ]; then
    echo "AGE key already exists"
else
    # create new age key
    age-keygen -o age_key.txt

    echo ""
    echo " Key created"
    echo ""

    # show public key (this is needed in send.sh)
    echo " COPY THIS PUBLIC KEY and paste in send.sh:"
    grep "public key:" age_key.txt
fi
