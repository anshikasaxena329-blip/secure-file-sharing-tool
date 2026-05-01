# This script is used to receive and verify files
# It decrypts the file and checks if it was changed or not

ENC_FILE=$1

# Check input
if [ -z "$ENC_FILE" ]; then
    echo "Usage: ./receive.sh file.age"
    exit 1
fi

if [ ! -f "$ENC_FILE" ]; then
    echo "Encrypted file not found!"
    exit 1
fi

# Check age installed
if ! command -v age &> /dev/null; then
    echo "age not installed!"
    exit 1
fi

echo "File received: $ENC_FILE"

# Decrypt file
OUT_FILE="${ENC_FILE%.age}"

echo "[+] Decrypting..."

if ! age -d -i ../age_key.txt -o "$OUT_FILE" "$ENC_FILE"; then
    echo "Decryption failed! Maybe wrong key."
    exit 1
fi

echo " Decryption successful"

# Check checksum file exists
CHECKSUM_FILE="$OUT_FILE.checksum"

if [ ! -f "$CHECKSUM_FILE" ]; then
    echo "Checksum file missing!"
    exit 1
fi

# Verify integrity
ORIGINAL_CHECKSUM=$(cat "$CHECKSUM_FILE")
NEW_CHECKSUM=$(sha256sum "$OUT_FILE" | awk '{print $1}')

echo "[+] Verifying integrity..."

STATUS="SUCCESS"

if [ "$ORIGINAL_CHECKSUM" == "$NEW_CHECKSUM" ]; then
    echo "File integrity verified"
else
    echo "File corrupted!"
    STATUS="FAILED (checksum)"
fi

# Log result
TIMESTAMP=$(date -Iseconds)

echo "$TIMESTAMP | receiver | local | $OUT_FILE | sha256:$NEW_CHECKSUM | $STATUS" >> transfer.log
