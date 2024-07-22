import requests
import json

# Replace "YOUR_API_KEY" with your actual API key
api_key = "YOUR_API_KEY"

# Set the base URL for the API
base_url = "https://api.thetvdb.com/"

# Set the endpoint for adding a movie
add_movie_endpoint = "movies"

# Set the headers for the API request
headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Authorization": f"Bearer {api_key}",
}

# Set the data for the movie you want to add
movie_data = {
    "name": "The Godfather",
    "release_date": "1972-03-24",
    "overview": "The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.",
    "imdb_id": "tt0068646",
}

# Convert the movie data to JSON format
movie_data_json = json.dumps(movie_data)

# Make the API request to add the movie
response = requests.post(base_url + add_movie_endpoint, headers=headers, data=movie_data_json)

# Check if the API request was successful
if response.status_code == 201:
    print("Movie added successfully!")
else:
    print("Error adding movie:", response.json())
