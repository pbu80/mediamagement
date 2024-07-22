import requests
import json
import argparse


BASE_URL = 'https://pbu80.hermes.usbx.me/tautulli/api/v2'

# Load the credentials from the .secret file
with open("/home/pbu80/scripts/.secret", "r") as f:
    credentials = dict(line.strip().split(": ") for line in f)

# Extract the TMDB API key from the credentials
API_KEY = credentials["tautulli_key"]


def get_user_history(user, api_key, base_url):
    movies = []
    page = 1
    page_size = 25

    while True:
        payload = {
            'apikey': api_key,
            'cmd': 'get_history',
            'user': user,
            'media_type': 'movie',
            'length': page_size,
            'start': (page - 1) * page_size,
        }
        response = requests.get(base_url, params=payload)
        data = response.json()

        if data['response']['result'] == 'success':
            history = data['response']['data']['data']
            if not history:
                break

            movies.extend(history)
            page += 1
        else:
            raise ValueError(f"Failed to fetch history for user {user}")

    return movies

def find_common_movies(user1_movies, user2_movies):
    return list(set(user1_movies).intersection(user2_movies))

def main():
    parser = argparse.ArgumentParser(description='Fetch movies watched by two users and find common movies')
    parser.add_argument('user1', type=str, help='Username of the first user')
    parser.add_argument('user2', type=str, help='Username of the second user')
    args = parser.parse_args()

    users = [args.user1, args.user2]
    movies_watched = {}

    for user in users:
        history = get_user_history(user, API_KEY, BASE_URL)
        movies_watched[user] = [movie['full_title'] for movie in history]

    with open('movies_watched.json', 'w') as outfile:
        json.dump(movies_watched, outfile, indent=2)

    common_movies = find_common_movies(movies_watched[users[0]], movies_watched[users[1]])

    with open('common_movies.json', 'w') as outfile:
        json.dump(common_movies, outfile, indent=2)

    print(f"Common movies between {users[0]} and {users[1]} have been saved to 'common_movies.json'")

if __name__ == '__main__':
    main()