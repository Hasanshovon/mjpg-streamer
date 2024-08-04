#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Update package list and install dependencies
sudo apt update

if [ "$(whoami)" == "pi" ]; then
    sudo apt install -y git cmake build-essential libjpeg62-turbo-dev
else
    sudo apt install -y git cmake build-essential libjpeg8
fi

# Clone the repository
git clone https://github.com/Hasanshovon/mjpg-streamer.git
cd mjpg-streamer/mjpg-streamer-experimental

# Build the project
make

# Install the binaries
sudo make install

# Clean up
#cd ../..
#rm -rf mjpg-streamer

echo "mjpg-streamer installation completed successfully."

# Run start.sh
#./start.sh
#echo "mjpg-streamer started successfully."

# Create systemd service file
sudo bash -c 'cat > /etc/systemd/system/mjpg-streamer.service <<EOF
[Unit]
Description=mjpg-streamer service
After=network.target


if [ "$(whoami)" == "pi" ]; then
    [Service]
    ExecStart=/home/pi/mjpg-streamer/mjpg-streamer-experimental/start.sh
    WorkingDirectory=/home/pi/mjpg-streamer/mjpg-streamer-experimental/
    Restart=always
    User=pi
elif [ "$(whoami)" == "jetson" ]; then
    ExecStart=/home/jetson/mjpg-streamer/mjpg-streamer-experimental/start.sh
    WorkingDirectory=/home/jetson/mjpg-streamer/mjpg-streamer-experimental/
    Restart=always
    User=jetson
fi
[Service]
ExecStart=/home/$(whoami)/mjpg-streamer/mjpg-streamer-experimental/start.sh
WorkingDirectory=/home/$(whoami)/mjpg-streamer/mjpg-streamer-experimental/
Restart=always
User=$(whoami)

[Install]
WantedBy=multi-user.target
EOF'

# Reload systemd, enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable mjpg-streamer.service
sudo systemctl start mjpg-streamer.service

# Check the status of the service
sudo systemctl status mjpg-streamer.service

echo "mjpg-streamer service installed and started successfully."
