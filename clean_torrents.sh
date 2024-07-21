#!/bin/bash

PREFIXFOLDER="processed"
PATTERN='\[[^]]+\]'
REPLACEMENT_PREFIX="{edition-"
REPLACEMENT_SUFFIX="}"

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

# Create the target directory if it doesn't exist
if [[ ! -d "${MEDIA_DIR}/${PREFIXFOLDER}" ]]; then
  mkdir "${MEDIA_DIR}/${PREFIXFOLDER}"
fi

# Function to replace language codes
replace_language_codes() {
  local input="$1"
  input=$(echo "$input" | sed -E 's/\bTam\b/Tamil/g')
  input=$(echo "$input" | sed -E 's/\bTel\b/Telugu/g')
  input=$(echo "$input" | sed -E 's/\bHin\b/Hindi/g')
  input=$(echo "$input" | sed -E 's/\bKan\b/Kannada/g')
  input=$(echo "$input" | sed -E 's/\bMal\b/Malayalam/g')
  input=$(echo "$input" | sed -E 's/\bKoi\b/Korean/g')
  input=$(echo "$input" | sed -E 's/\bEng\b/English/g')
  input=$(echo "$input" | sed -E 's/\bRus\b/Russian/g')
  input=$(echo "$input" | sed -E 's/\bChi\b/Chinese/g')
  echo "$input"
}

# Look for media files containing "www" in their name
for FILE in "${MEDIA_DIR}"/*www*; do

  # Get the portion of the file name after the first "-"
  NEW_NAME=$(basename "$FILE" | sed 's/^[^-]*- //')

  echo "Original file name: $FILE"
  echo "New name after removing prefix: $NEW_NAME"

  # Detect and replace the pattern
  if [[ "$NEW_NAME" =~ $PATTERN ]]; then
    echo "Pattern detected in: $NEW_NAME"
    LANGUAGES=$(echo "$NEW_NAME" | grep -o -E "$PATTERN" | sed 's/^\[//;s/\]$//')
    REPLACED_LANGUAGES=$(replace_language_codes "$LANGUAGES")
    NEW_NAME=$(echo "$NEW_NAME" | sed "s/\[$LANGUAGES\]/${REPLACEMENT_PREFIX}${REPLACED_LANGUAGES}${REPLACEMENT_SUFFIX}/")
    echo "New name after pattern replacement: $NEW_NAME"
  else
    echo "No pattern detected in: $NEW_NAME"
  fi

  # Rename the file
  if mv "$FILE" "${MEDIA_DIR}/${PREFIXFOLDER}/${NEW_NAME}"; then
    echo "Moved $FILE to ${MEDIA_DIR}/${PREFIXFOLDER}/${NEW_NAME}"
  else
    echo "Failed to move $FILE"
  fi

done
