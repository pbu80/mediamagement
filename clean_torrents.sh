#!/bin/bash

PREFIXFOLDER="processed"
# Check if the path argument is provided
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 path/to/media/files"
  exit 1
fi

# Define the directory where media files are located
MEDIA_DIR="$1"

# Check if there are any files in MEDIA_DIR that contain "www"
if ! ls "${MEDIA_DIR}"/*www* > /dev/null 2>&1; then
  echo "No media files found in ${MEDIA_DIR} containing 'www'"
  exit 1
fi

# Look for media files containing "www" in their name
for FILE in "${MEDIA_DIR}"/*www*; do

  # Get the portion of the file name after the first "-"
  NEW_NAME=$(echo "$FILE" | sed 's/^[^-]*- //')

  # Rename the file
  mv "$FILE" "${MEDIA_DIR}/${PREFIXFOLDER}/${NEW_NAME}"

done
