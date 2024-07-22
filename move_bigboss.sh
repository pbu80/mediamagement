#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 'FOLDER_NAME'"
    exit 1
fi

# Extract the folder name from the argument
FOLDER_NAME="$1"

# Extract top-level and second-level folder names
TOP_LEVEL_FOLDER=$(echo "$FOLDER_NAME" | grep -oP '^[^(]+\(\K[^)]+')
SEASON_NUMBER=$(echo "$FOLDER_NAME" | grep -oP '(?<= S)[0-9]{1,2}')

# Convert season number to a folder name with leading zero, e.g., "S07" -> "Season 07"
SECOND_LEVEL_FOLDER="Season $(printf "%02d" "$SEASON_NUMBER")"

# Check and create the top-level folder if it does not exist
if [ ! -d "${TOP_LEVEL_FOLDER}" ]; then
    mkdir -p "${TOP_LEVEL_FOLDER}"
fi

# Check and create the second-level folder if it does not exist
if [ ! -d "${TOP_LEVEL_FOLDER}/${SECOND_LEVEL_FOLDER}" ]; then
    mkdir -p "${TOP_LEVEL_FOLDER}/${SECOND_LEVEL_FOLDER}"
fi

# Move all files to the new directory structure
# Note: you should customize the file selecting pattern (*.*) and source directory (.) according to your needs
# Also ensure to modify this according to where your input files are and where you want them to go
mv ./*.* "${TOP_LEVEL_FOLDER}/${SECOND_LEVEL_FOLDER}/"

# Notify user
echo "Files have been moved to ${TOP_LEVEL_FOLDER}/${SECOND_LEVEL_FOLDER}/"
