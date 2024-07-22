import os
import sys
import subprocess

SUBCLEAN_PATH = "/home/pbu80/scripts/subcleaner/subcleaner.py"
PROCESSED_FILES_PATH = "/home/pbu80/logs/.cleaned_srts"

MAX_DEPTH = 2

def clean_srt_files(path):
    processed_files = load_processed_files()
    for dirpath, dirnames, filenames in os.walk(path):
        depth = dirpath[len(path) + len(os.path.sep):].count(os.path.sep)
        if depth > MAX_DEPTH:
            continue
        for filename in filenames:
            if filename.endswith('.srt') and filename not in processed_files:
                file_path = os.path.join(dirpath, filename)
                print(f"Cleaning {file_path}")
                subprocess.run(['python', SUBCLEAN_PATH, file_path], check=True)
                mark_file_as_processed(filename)

def load_processed_files():
    if not os.path.exists(PROCESSED_FILES_PATH):
        return set()
    with open(PROCESSED_FILES_PATH, 'r') as f:
        return set(line.strip() for line in f)

def mark_file_as_processed(filename):
    with open(PROCESSED_FILES_PATH, 'a') as f:
        f.write(filename + '\n')

if __name__ == '__main__':
    path = sys.argv[1]
    clean_srt_files(path)