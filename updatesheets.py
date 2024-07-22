import gspread
from oauth2client.service_account import ServiceAccountCredentials

# Set up credentials for Google Sheets API
scope = ['https://spreadsheets.google.com/feeds', 'https://www.googleapis.com/auth/drive']
creds = ServiceAccountCredentials.from_json_keyfile_name('sheetcreds.json', scope)
client = gspread.authorize(creds)

# Open the Google Sheet
sheet = client.open('updatetest').sheet1

# Define the data to add to the sheet
data = ["New Row Data1", "New Row Data2", "New Row Data3"]

# Add the data to a new row in the sheet
sheet.append_row(data)

print("Data added to sheet successfully!")
