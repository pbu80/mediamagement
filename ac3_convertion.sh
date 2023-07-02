#!/bin/bash

# Check if FFmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    echo "FFmpeg is not installed. Please install FFmpeg and try again."
    exit 1
fi

# Check if input file is provided
if [ -z "$1" ]; then
    echo "Please provide the input media file as an argument."
    exit 1
fi

# Check if the input file exists
if [ ! -f "$1" ]; then
    echo "Input file '$1' not found."
    exit 1
fi

# Check if the input file contains "EAC3" in the filename
if [[ ! "$1" == *"EAC3"* ]]; then
    echo "Input file does not contain 'EAC3' in the filename."
    exit 1
fi

# Log file path
log_file="~/logs/ac3_conversion.log"

# Check if the log file exists, if not create a new log file
if [ ! -f "$log_file" ]; then
    touch "$log_file"
fi

# Check if the input file is already processed (present in the log file), if so, skip the conversion
if grep -Fxq "$1" "$log_file"; then
    echo "File already processed. Skipping conversion: $1"
    exit 0
fi

# Set the output file name
output_file="${1/EAC3/AC3}"

# Convert the audio from EAC3 to AC3 using FFmpeg
ffmpeg -i "$1" -c:v copy -c:a ac3 -map 0 "$output_file"

# Check if conversion was successful
if [ $? -eq 0 ]; then
    echo "Conversion complete. Output file: $output_file"
    
    # Add the input file to the log file
    echo "$1" >> "$log_file"
else
    echo "An error occurred during the conversion."
fi
