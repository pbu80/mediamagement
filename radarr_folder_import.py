import requests
import os

# Set API Key and base URL for Radarr
API_KEY = "a28cb570181b43dab230f6b857d3fd76"
BASE_URL = "http://127.0.0.1:7878/api/v3"

# Set folder path for movies to import
FOLDER_PATH = "/home/pbu80/Stuff/local/Indian/"

# Get list of files in folder
files = os.listdir(FOLDER_PATH)

# Iterate over files and subfolders in folder
for root, dirs, files in os.walk(FOLDER_PATH):
    # Iterate over files in current folder
    for file in files:
        # Only import movie files
        if file.endswith((".mkv", ".mp4", ".avi", ".mov")):
            # Set parameters for Radarr API call
            params = {
                "apikey": API_KEY,
                "folderPath": root,
                "importMode": "Copy",
                "qualityProfileId": 1,
                "monitor": True,
                "title": file
            }
            # Make POST request to Radarr API
            response = requests.post(BASE_URL + "/movie", params=params)
            # Check if request was successful
            if response.status_code == 201:
                print(file + " imported successfully")
            else:
                print("Error importing " + file + ": " + response.text)