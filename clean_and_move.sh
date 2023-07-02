#!/bin/bash

#example: /home/pbu80/scripts/clean_and_move.sh /home/pbu80/MergerFS/downloads/torrents/manual/tamil /home/pbu80/MergerFS/Tamil/ /home/pbu80/logs/tamil.log

# Check if a path was provided as input
if [ -z "$1" ]; then
  echo "Please provide a path as input."
  exit 1
fi

dst_folder="$2"

log_file="$3"


# clean file name 
bash "/home/pbu80/scripts/clean_torrents.sh" "$1" >> "$log_file" 2>&1

# move the file to a folder
bash "/home/pbu80/scripts/movie2folder.sh" "$1/processed/" >> "$log_file" 2>&1

#python "/home/pbu80/scripts/rename_folders.py" "$1" "$1" >> "$log_file" 2>&1

# clean mkv file
bash "/home/pbu80/scripts/mkvclean.v3.sh" "$1/processed/" >> "$log_file" 2>&1

#move the 
mv "$1"/processed/* "$dst_folder"

