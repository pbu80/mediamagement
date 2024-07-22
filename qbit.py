import requests
import json

# API URL
url = 'http://localhost:12141/api/v2/torrents/info'

# API request headers
headers = {'content-type': 'application/json'}

# Send API request
response = requests.get(url, headers=headers)

# Try to parse JSON response
try:
    torrents = json.loads(response.content.decode('utf-8'))
    for torrent in torrents:
        print(torrent['name'])
except json.decoder.JSONDecodeError as e:
    print(f'Error: {e}')
    print(f'Response content: {response.content}')
