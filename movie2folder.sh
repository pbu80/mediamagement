#!/bin/bash

# Get the root directory from the first argument
root_dir="$1"

# Check if the root directory exists
if [ ! -d "$root_dir" ]; then
  echo "Error: $root_dir does not exist or is not a directory."
  exit 1
fi

# Loop through all mkv and mp4 files in the root directory
for file in "$root_dir"/*.mkv "$root_dir"/*.mp4; do
  # Check if the file exists and is a regular file
  if [ -f "$file" ]; then
    # Extract the filename without extension
    filename=$(basename -- "$file")
    filename="${filename%.*}"

    # Create a folder with the same name as the filename
    mkdir "$root_dir/$filename"

    # Move the file into the newly created folder
    mv "$file" "$root_dir/$filename"
    echo $file
  fi
done
