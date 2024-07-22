#!/bin/bash
if [ $# -eq 0 ]; then
  echo "No folder path provided. Please provide a folder path as an argument."
  exit 1
fi

# Find all .mkv files in the specified directory and its subdirectories
while IFS= read -r -d $'\0' file; do
  # Print the name of the file
  echo "Processing $file..."

  mkvpropedit "$file" --edit track:v1 --delete name --edit track:a1 --delete name --edit track:s1 --delete name || true
done < <(find "$1" -name "*.mkv" -print0)

