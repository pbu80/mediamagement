echo "[UNRAR SCRIPT START]"
find /home/pbu80/Stuff/local/downloads/torrents/transmission -name "*.rar" -execdir unrar e -o- "{}" \;
