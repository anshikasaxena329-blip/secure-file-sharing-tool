#!/bin/bash

# ===============================
# SECURE FILE SENDER SCRIPT
# ===============================

# Step 1: take file name as input
FILE=$1

# Step 2: paste your AGE public key here
PUBKEY="age1wwzvutk57kau8c4xe8fmpyhye5yunqvzk5d5carvhgs2avt5vg4q8ewrlz"
# Step 3: where to send file (same server → folder)
DEST_FOLDER="./receiver_folder"

# Step 4: log file name
LOGFILE="transfer.log"

# ===============================
# CHECK INPUT
# ===============================

# if no file given
if [ -z "$FILE" ]; then
    echo " Please provide file name"
    echo "Usage: ./send.sh notes.txt"
    exit 1
fi

# if file does not exist
if [ ! -f "$FILE" ]; then
    echo " File not found!"
    exit 1
fi

echo " File selected: $FILE"

# ===============================
# GENERATE CHECKSUM
# ===============================

# create hash of file (for integrity check)
CHECKSUM=$(sha256sum "$FILE" | awk '{print $1}')
echo " Checksum: $CHECKSUM"

# ===============================
# ENCRYPT FILE
# ===============================

ENCRYPTED_FILE="$FILE.age"

echo " Encrypting file..."

# encrypt using age public key
age -r "$PUBKEY" -o "$ENCRYPTED_FILE" "$FILE"

# check if encryption worked
if [ $? -ne 0 ]; then
    echo " Encryption failed!"

    STATUS="FAILED (encryption)"

    # log failure
    TIMESTAMP=$(date +"%Y-%m-%dT%H:%M:%S")
    echo "$TIMESTAMP | sender | receiver | $FILE | sha256:$CHECKSUM | $STATUS" >> "$LOGFILE"

    exit 1
fi

echo " Encryption successful"

# ===============================
# TRANSFER FILE
# ===============================

echo " Transferring file..."

# create receiver folder if not exists
mkdir -p "$DEST_FOLDER"

# copy encrypted file
cp "$ENCRYPTED_FILE" "$DEST_FOLDER/"

# also send checksum file
echo "$CHECKSUM" > "$DEST_FOLDER/$FILE.checksum"

# check if transfer worked
if [ $? -ne 0 ]; then
    echo " Transfer failed!"
    STATUS="FAILED (transfer)"
else
    echo " Transfer successful"
    STATUS="SUCCESS"
fi

# ===============================
# LOGGING
# ===============================

TIMESTAMP=$(date +"%Y-%m-%dT%H:%M:%S")

echo "$TIMESTAMP | sender | receiver | $FILE | sha256:$CHECKSUM | $STATUS" >> "$LOGFILE"

echo " Logged Sucessfully "
