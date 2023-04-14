import os
import sys
import re
import requests
import shutil

# Load the credentials from the .secret file
with open("/home/pbu80/scripts/.secret", "r") as f:
    credentials = dict(line.strip().split(": ") for line in f)

# Extract the TMDB API key from the credentials
api_key = credentials["tmdb_key"]

# Function to fetch movie details from TMDB API
def fetch_movie_details(title, year):
    # Replace spaces with %20 for the URL
    title = title.replace(" ", "%20")

    # Make a GET request to TMDB API
    response = requests.get(f"https://api.themoviedb.org/3/search/movie?api_key={api_key}&query={title}&year={year}")
    
    # Extract the JSON data from the response
    data = response.json()

    # Check if any movies were found
    if data["total_results"] > 0:
        # Return the details of the first movie found
        return data["results"][0]

    # No movies found
    return None

# Function to clean the title for better matching
def clean_title(title):
    # Remove any special characters like ()/-[]
    cleaned_title = re.sub(r'[^\w\s]','',title)
    return cleaned_title

# Function to process a single media file
def process_file(file_path, root_path):
    # Check if the file is a video file
    if file_path.endswith(".mkv") or file_path.endswith(".mp4"):
        # Extract the name of the file without the extension
        file_name = os.path.splitext(os.path.basename(file_path))[0]

        # Extract the name and year of the movie from the file name
        movie_name = file_name.split("(")[0].strip()
        match = re.search(r"\b\d{4}\b", file_name)
        movie_year = match.group(0) if match else None

        # Clean the movie name for better matching
        cleaned_movie_name = clean_title(movie_name)

        # Fetch the movie details from TMDB API
        movie_details = fetch_movie_details(cleaned_movie_name, movie_year)

        if movie_details is not None:
            # Extract the movie name and year from the movie details
            movie_name = movie_details["title"]
            movie_year = movie_details["release_date"][:4]

            # Clean the movie name and year for folder naming
            folder_name = f"{clean_title(movie_name)} ({movie_year})"
            folder_path = os.path.join(root_path, folder_name)

            # Check if the folder already exists
            if not os.path.exists(folder_path):
                # Create a new folder for the movie
                os.makedirs(folder_path)

            # Move the file to the movie folder
            new_file_path = os.path.join(folder_path, os.path.basename(file_path))
            shutil.move(file_path, new_file_path)

            print(f"Moved {file_path} to {new_file_path}")

            # Rename the movie folder with the movie year
            old_folder_path = os.path.dirname(new_file_path)
            new_folder_path = os.path.join(root_path, folder_name)
            if old_folder_path != new_folder_path:
                os.rename(old_folder_path, new_folder_path)
                print(f"Renamed folder {old_folder_path} to {new_folder_path}")
        else:
            print(f"No movie found for {movie_name} ({movie_year})")




# Function to process a single file or directory
def process_path(path, root_path):
    if os.path.isfile(path):
        process_file(path, root_path)
    elif os.path.isdir(path):
        for file_name in os.listdir(path):
            file_path = os.path.join(path, file_name)
            process_path(file_path, root_path)
    else:
        print(f"Invalid path: {path}")

if __name__ == "__main__":
    # Get the path to process from the command line arguments
    path = sys.argv[1]

    # Get the root directory from the command line arguments
    root_path = sys.argv[2]

    # Process the path
    if os.path.isfile(path):
        process_file(path, root_path)
    elif os.path.isdir(path):
        for dirpath, dirnames, filenames in os.walk(path):
            for file_name in filenames:
                file_path = os.path.join(dirpath, file_name)
                process_file(file_path, root_path)
    else:
        print(f"Invalid path: {path}")

