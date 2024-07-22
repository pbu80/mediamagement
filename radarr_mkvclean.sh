#!/bin/bash
echo $radarr_moviefile_path 
# Check if radarr_movie_path variable is set
if [ -z "$radarr_movie_path" ]; then
  echo "radarr_movie_path variable is not set. Please set the variable with the movie directory path."
  exit 1
fi

# Find all .mkv files in the specified directory and its subdirectories
while IFS= read -r -d $'\0' file; do
  # Print the name of the file
  echo "Processing $file..."

  # Use mkvmerge to determine the number of attachments in the file
  num_attachments=$(mkvmerge -i "$file" | grep -c "Attachment ID")
  
  if [ "$num_attachments" -gt 0 ]; then
    # Use mkvpropedit to remove each attachment from the file, starting from index 1
    for i in $(seq 1 $num_attachments); do
      mkvpropedit "$file" --delete-attachment $i
    done
  fi
done < <(find "$radarr_movie_path" -name "*.mkv" -print0)

