#!/bin/bash
if [ $# -eq 0 ]; then
  echo "No folder path provided. Please provide a folder path as an argument."
  exit 1
fi
# Set the name of the file to store the list of processed files
processed_file="/home/pbu80/logs/.processed_files"

# Create the processed file if it doesn't exist
touch "$processed_file"

# Find all .mkv files in the specified directory and its subdirectories
while IFS= read -r -d $'\0' file; do
  if grep -Fxq "$(basename "$file")" "$processed_file"; then
    echo "Skipping $file (already processed)."
  else  
    
    # Print the name of the file
    echo "Processing $file..."

    # Use mkvmerge to determine the number of tracks in the file
    tracks=$(mkvmerge -i "$file" | grep -c "Track ID")
  
    # Use mkvpropedit to remove the name property of each track
    for i in $(seq 1 $tracks); do
      mkvpropedit "$file" --edit track:$i --delete name 
      mkvpropedit "$file" -d title
    done
  
    num_attachments=$(mkvmerge -i "$file" | grep -c "Attachment ID")
    
    if [ "$num_attachments" -gt 0 ]; then
      # Use mkvpropedit to remove each attachment from the file, starting from index 1
      for j in $(seq 1 $num_attachments); do
        mkvpropedit "$file" --delete-attachment $j
      done
    fi
    echo "$(basename "$file")" >> "$processed_file" 
  fi  
done < <(find "$1" -name "*.mkv" -print0)

