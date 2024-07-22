#!/bin/bash

# Check if mkvinfo is installed
if ! command -v mkvinfo &> /dev/null
then
    echo "mkvinfo could not be found. Please install mkvtoolnix."
    exit
fi

# Check if the path to the MKV files was provided as an argument
if [ -z "$1" ]
then
    echo "Please provide the path to the MKV files as an argument."
    exit
fi

# Get the path to the MKV files from the argument
path="$1"

# Check if the path exists
if [ ! -d "$path" ]
then
    echo "Directory $path not found."
    exit
fi

# Find all MKV files in the path
mkv_files=$(find "$path" -type f -name "*.mkv")

# Loop through each MKV file and check if it contains metadata with the string "www"
while IFS= read -r mkv_file
do
    # Use mkvinfo to get the metadata of the MKV file
    metadata=$(mkvinfo "$mkv_file")

    # Check if the metadata contains the string "www"
    if [[ $metadata == *"www"* ]]
    then
        # Save the output to a text file with the full path info
        echo "The file \"$mkv_file\" contains metadata with the string 'www':" >> "$path/metadata.txt"
        echo "$metadata" >> "$path/metadata.txt"
        echo "" >> "$path/metadata.txt"
    fi
done <<< "$mkv_files"

echo "Metadata extraction complete. Output saved to $path/metadata.txt"
