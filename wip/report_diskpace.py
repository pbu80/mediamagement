import psutil
import requests
import json

# Define the URL of the Home Assistant server
url = "https://ha.pbu80.in/api/states/sensor.disk_free"

# Define the authentication token for the Home Assistant API
headers = {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiIwYjgwMzkyNzQ4MGU0ZmI5OTMyM2ExZTI5ZGMwNDZmNyIsImlhdCI6MTY4MzAzNDg5OSwiZXhwIjoxOTk4Mzk0ODk5fQ.eFRXZxzHKw1Vybhya1VdFbunQo2T-PCjVXy0D8gvEPs",
    "Content-Type": "application/json",
}

# Get the disk usage information
disk_usage = psutil.disk_usage('/')

# Define the payload to send to the Home Assistant server
payload = {
    "state": disk_usage.free,
    "attributes": {
        "unit_of_measurement": "bytes",
        "friendly_name": "Disk Free",
        "icon": "mdi:harddisk",
        "total": disk_usage.total,
        "used": disk_usage.used,
    },
}

# Convert the payload to JSON format
data = json.dumps(payload)

# Send the payload to the Home Assistant server
response = requests.post(url, headers=headers, data=data)
print(response)
# Check if the request was successful
if response.status_code == 200:
    print("Disk free reported successfully!")
else:
    print("Failed to report disk free.")
