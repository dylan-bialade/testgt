#!/bin/bash

# Update and upgrade system
sudo apt update && sudo apt upgrade -y

# Install necessary packages
sudo apt-get install -y unzip
sudo apt install -y default-jdk openssh-server apache2 ufw

# Start and enable SSH
sudo systemctl start ssh
sudo systemctl enable ssh

# Check SSH status
sudo systemctl status ssh

# Add Apache PPA and update
sudo add-apt-repository ppa:ondrej/apache2 -y
sudo apt update

# Enable UFW and allow specific IPs
sudo ufw enable
sudo ufw allow from 52.214.221.145
sudo ufw allow from 52.50.207.205
sudo ufw allow from 34.255.188.27
sudo ufw allow from 109.0.28.108
sudo ufw allow from 52.211.149.81
sudo ufw allow from 52.49.122.126
sudo ufw allow from 54.76.16.128
sudo ufw allow from 94.185.65.65

# Configure Apache headers
echo -e "Header set Access-Control-Allow-Origin \"https://apps.sogelink.fr\"\nHeader set Access-Control-Allow-Origin \"https://staging.apps.sogelink.fr\"\nHeader set Access-Control-Allow-Origin \"https://inte.apps.sogelink.fr\"\n" | sudo tee /etc/apache2/conf-available/custom-headers.conf
sudo a2enconf custom-headers
sudo systemctl reload apache2

# Download and unzip GeoServer
wget https://sourceforge.net/projects/geoserver/files/GeoServer/2.21.0/geoserver-2.21.0-bin.zip
sudo mkdir -p /usr/share/geoserver
sudo unzip -d /usr/share/geoserver/ geoserver-2.21.0-bin.zip

# Create GeoServer user
sudo useradd -m -U -s /bin/false geoserver
sudo chown -R geoserver:geoserver /usr/share/geoserver

# Create GeoServer systemd service
echo -e "[Unit]\nDescription=GeoServer Service\nAfter=network.target\n\n[Service]\nType=simple\nUser=geoserver\nGroup=geoserver\nEnvironment=\"GEOSERVER_HOME=/usr/share/geoserver\"\nExecStart=/usr/share/geoserver/bin/startup.sh\nExecStop=/usr/share/geoserver/bin/shutdown.sh\n\n[Install]\nWantedBy=multi-user.target\n" | sudo tee /etc/systemd/system/geoserver.service

# Reload systemd, enable and start GeoServer
sudo systemctl daemon-reload
sudo systemctl enable --now geoserver

# Check GeoServer status
ss -antpl | grep 8080
sudo systemctl status geoserver
