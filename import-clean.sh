#!/bin/bash

# This script uses mkvpropedit to clean the metadata of an imported movie file

# Define the path to mkvpropedit
MKVPROPEXEC=/home/pbu80/scripts/mkvpropedit

# Define the path to the imported movie file
MOVIEFILE="${radarr_moviefile_path}"

# Wait for 1 minute before processing the file
sleep 60

# Use mkvpropedit to clean the metadata of the movie file
"$MKVPROPEXEC" "$MOVIEFILE" --tags all: --delete-attachment name:cover.jpg --delete-attachment name:cover.png

  tracks=$(mkvmerge -i "$MOVIEFILE" | grep -c "Track ID")
  
  # Use mkvpropedit to remove the name property of each track
  for i in $(seq 1 $tracks); do
    mkvpropedit "$MOVIEFILE" --edit track:$i --delete name 
    mkvpropedit "$MOVIEFILE" -d title
  done

  num_attachments=$(mkvmerge -i "$MOVIEFILE" | grep -c "Attachment ID")
  
  if [ "$num_attachments" -gt 0 ]; then
    # Use mkvpropedit to remove each attachment from the file, starting from index 1
    for j in $(seq 1 $num_attachments); do
      mkvpropedit "$MOVIEFILE" --delete-attachment $j
    done
  fi
#append movie name

echo "$(date): Imported movie $radarr_movie_title" >> /home/pbu80/logs/logfile.log

# Exit the script
exit 0
