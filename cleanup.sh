#!/bin/bash
find /home/pbu80/MergerFS/downloads/torrents/qbittorent/* -type d -ctime +20 -exec rm -rf {} \;