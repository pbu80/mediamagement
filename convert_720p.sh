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

for file in "$src_folder"/*.mkv; do
  if [ -f "$file" ] && [[ "$file" != *"720p"* ]]; then
    filename=$(basename "$file")
    output_file="$dst_folder/${filename/1080p/720p}"
    output_file="${output_file/5.1/2.0}"
    command="ffmpeg -i '$file' -vf scale=-1:720 -c:v libx264 -preset slow -crf 22 -c:a aac -b:a 192k -ac 2 '$output_file'"
    eval $command

    if [ $? -ne 0 ]; then
        command="ffmpeg -i '$file' -filter:v "crop=1744:720:0:0" -c:v libx264 -preset slow -crf 22 -c:a aac -b:a 192k -ac 2 '$output_file'"
        #eval $command
    fi

  fi
done

# Handle srt files
for srt_file in "$src_folder"/*.srt; do
  if [ -f "$srt_file" ] && [[ "$srt_file" != *"720p"* ]]; then
    filename=$(basename "$srt_file")
    new_srt_file="$dst_folder/${filename/1080p/720p}"
    cp "$srt_file" "$new_srt_file"
  fi
done
