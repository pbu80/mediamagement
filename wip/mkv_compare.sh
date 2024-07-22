#!/bin/bash

# Check if mkvinfo is installed
if ! command -v mkvinfo &> /dev/null; then
    echo "mkvinfo is not installed. Please install mkvtoolnix package."
    exit 1
fi

# Check if two file paths are provided as arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file1.mkv> <file2.mkv>"
    exit 1
fi

file1="$1"
file2="$2"

# Check if the provided files exist
if [ ! -f "$file1" ] || [ ! -f "$file2" ]; then
    echo "One or both of the files do not exist."
    exit 1
fi

# Extract information from file1
file1_info=$(mkvinfo "$file1" | sed -n '/\+ EBML head/,/Segment tracks/p')

# Extract information from file2
file2_info=$(mkvinfo "$file2" | sed -n '/\+ EBML head/,/Segment tracks/p')

# Find the common lines between the two files
common_lines=$(comm -12 <(echo "$file1_info" | sort) <(echo "$file2_info" | sort))

# Find the unique lines in file1
unique_lines_file1=$(comm -23 <(echo "$file1_info" | sort) <(echo "$common_lines" | sort))

# Find the unique lines in file2
unique_lines_file2=$(comm -13 <(echo "$file2_info" | sort) <(echo "$common_lines" | sort))

# Print the similarities
echo "Similarities between $file1 and $file2:"
if [ -z "$common_lines" ]; then
    echo "None"
else
    echo "$common_lines"
fi

# Print the differences
echo
echo "Differences between $file1 and $file2:"
echo "Unique lines in $file1:"
if [ -z "$unique_lines_file1" ]; then
    echo "None"
else
    echo "$unique_lines_file1"
fi

echo
echo "Unique lines in $file2:"
if [ -z "$unique_lines_file2" ]; then
    echo "None"
else
    echo "$unique_lines_file2"
fi
