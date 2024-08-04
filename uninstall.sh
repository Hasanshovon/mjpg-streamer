#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Optionally, remove the source directory if it still exists
sudo rm -rf ~/mjpg-streamer
echo "Directory removed"

# Stop the service
sudo systemctl stop mjpg-streamer.service

# Disable the service
sudo systemctl disable mjpg-streamer.service

# Remove the service file
sudo rm /etc/systemd/system/mjpg-streamer.service

# Reload systemd to apply changes
sudo systemctl daemon-reload

# Remove the installed binaries
#sudo rm /usr/local/bin/mjpg_streamer
#sudo rm /usr/local/bin/input_uvc.so
#sudo rm /usr/local/bin/output_http.so



echo "mjpg-streamer service uninstalled successfully."
