echo "[UNRAR SCRIPT START]"
find $TR_TORRENT_DIR/$TR_TORRENT_NAME -name "*.rar" -execdir unrar e -o- "{}" \;
