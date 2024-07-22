#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 [path]"
  exit 1
fi

if [ ! -d "$1" ]; then
  echo "Error: $1 is not a directory"
  exit 1
fi

rarPath="$1"
foundFiles=false

while IFS= read -r -d '' rarFile; do
  foundFiles=true
  echo "Extracting $rarFile..."
  dirName=$(dirname "$rarFile")
  baseName=$(basename "$rarFile" .rar)
  
  mkdir -p "$dirName/$baseName"
  unrar x -o+ "$rarFile" "$dirName/$baseName/"
  echo "Extraction complete."
done < <(find "$rarPath" -type f -name '*.rar' -print0)

if [ "$foundFiles" = false ]; then
  echo "No files to extract"
fi
