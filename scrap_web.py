import requests
from bs4 import BeautifulSoup

# Send a GET request to the URL
url = "https://tamilmv.unblockit.click"
response = requests.get(url)

# Parse the HTML content using BeautifulSoup
soup = BeautifulSoup(response.content, 'html.parser')

# Find the desired element(s) in the HTML
element = soup.find('script', class_='title')
print(element)

# Extract the data from the element(s)
data = element.text.strip()

# Print the extracted data
print(data)
