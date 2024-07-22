import requests
import json
import datetime

# API URL
url = 'http://localhost:12141/api/v2'

# API request headers
headers = {'content-type': 'application/json'}

# Get list of all torrents
torrents_url = f'{url}/torrents/info'
response = requests.get(torrents_url, headers=headers)
torrents = json.loads(response.content.decode('utf-8'))

# Find torrents with data older than 20 days
today = datetime.datetime.now()
twenty_days_ago = today - datetime.timedelta(days=19)
torrents_to_delete = []
for torrent in torrents:
    data_date = datetime.datetime.fromtimestamp(torrent['added_on'])
    if data_date <= twenty_days_ago:
        torrents_to_delete.append(torrent)

# Delete torrents with data older than 20 days
for torrent in torrents_to_delete:
    delete_url = f'{url}/torrents/delete'
    data = {'hashes': torrent['hash']}
    response = requests.post(delete_url, headers=headers, data=json.dumps(data))
    if response.status_code == 200:
        print(f'Deleted torrent: {torrent["name"]}')
    else:
        print(f'Error deleting torrent: {response.status_code} - {response.content.decode("utf-8")}')
