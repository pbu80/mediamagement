import speedtest

# Create a Speedtest object
st = speedtest.Speedtest()

# Find the download speed in Mbps
download_speed = st.download() / 1000000

# Find the upload speed in Mbps
upload_speed = st.upload() / 1000000

# Print the results
print(f"Download speed: {download_speed:.2f} Mbps")
print(f"Upload speed: {upload_speed:.2f} Mbps")
