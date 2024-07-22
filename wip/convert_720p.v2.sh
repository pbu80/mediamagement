#!/bin/bash

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Usage: $0 <source_folder> [<destination_folder>]"
  exit 1
fi

src_folder="$1"
if [ ! -d "$src_folder" ]; then
  echo "Invalid source folder: $src_folder"
  exit 1
fi

if [ $# -eq 2 ]; then
  dst_folder="$2"
  if [ ! -d "$dst_folder" ]; then
    echo "Invalid destination folder: $dst_folder"
    exit 1
  fi
else
  dst_folder="$src_folder"
fi

# Set the name of the file to store the list of processed files
processed_file="/home/pbu80/logs/.converted_files"

# Create the processed file if it doesn't exist
touch "$processed_file"

counter=0
while IFS= read -r -d $'\0' file; do
  if grep -Fxq "$(basename "$file")" "$processed_file"; then
    echo "Skipping $file (already processed)."
  else 

    for file in "$src_folder"/*.mkv; do
      if [ -f "$file" ] && [[ "$file" != *"720p"* ]]; then
        filename=$(basename "$file")
        output_file="$dst_folder/${filename/1080p/720p}"
        ffmpeg -i "$file" -vf scale=-1:720 -c:v libx264 -preset slow -crf 22 -c:a aac -b:a 192k -ac 2 "$output_file"
      fi
    
    
    # Handle srt files
    for srt_file in "$src_folder"/*.srt; do
      if [ -f "$srt_file" ] && [[ "$srt_file" != *"720p"* ]]; then
        filename=$(basename "$srt_file")
        new_srt_file="$dst_folder/${filename/1080p/720p}"
        cp "$srt_file" "$new_srt_file"
      fi
    
    echo "$(basename "$file")" >> "$processed_file" 
    # Increment the counter
    ((counter++))

    # Exit the loop if the counter reaches 100
    if [ "$counter" -eq 1 ]; then
      echo "Processed 1 files. Exiting."
      exit 0
    fi
    
done < <(find "$1" -name "*.mkv" -print0)

