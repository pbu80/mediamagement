#!/bin/bash

# This script takes a path as an argument
path="$1"

# Check if the path exists
if [ ! -d "$path" ]; then
  echo "Error: $path does not exist or is not a directory."
  exit 1
fi

# Find all mkv files in the path
for file in "$path"/*.mkv; do
  # Check if the file exists
  if [ ! -f "$file" ]; then
    continue
  fi

  # Print the file name
  echo "File: $file"

  # Get the track information for the file
  track_info=$(mkvmerge --identify "$file")

  # Print the track information
  echo "$track_info"
  echo
done

