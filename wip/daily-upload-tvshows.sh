rclone move "$HOME"/Stuff/local/TVShows gcrypt:TVShows \
 --config="$HOME"/.config/rclone/rclone.conf \
 --drive-chunk-size 64M \
 --tpslimit 5 \
 --min-age 30d \
 -vvv \
 --drive-stop-on-upload-limit \
 --delete-empty-src-dirs \
 --fast-list \
 --bwlimit=20M \
 --use-mmap \
 --transfers=2 \
 --checkers=4\ 
 --log-file "$HOME"/scripts/upload-tvshows.log