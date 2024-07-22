import os
import time

# Set the path to monitor
path = '/home/pbu80/Stuff/local/Tamil/'

# Set the file extensions to monitor for
extensions = ['.mkv', '.mp4']

# Set the path of the log file
log_file = '/home/pbu80/logs/folderinfo.txt'

# Initialize the list of existing folders
existing_folders = []

# Loop through each file in the path
for file in os.listdir(path):
    # Check if the file has the correct extension
    if file.endswith(tuple(extensions)):
        # Get the folder path of the file
        folder_path = os.path.join(path, os.path.dirname(file))
        
        # Log the folder path of the file to the log file
        with open(log_file, 'a') as f:
            f.write(folder_path + '\n')
