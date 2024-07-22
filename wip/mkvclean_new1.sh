#!/bin/bash
if [ $# -eq 0 ]; then
  echo "No folder path provided. Please provide a folder path as an argument."
  exit 1
fi

# Find all .mkv files in the specified directory and its subdirectories
while IFS= read -r -d $'\0' file; do
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
done < <(find "$1" -name "*.mkv" -print0)

