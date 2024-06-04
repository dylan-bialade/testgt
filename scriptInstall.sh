apt install default-jdk -y
sudo apt update && sudo apt upgrade
sudo apt install openssh-server
sudo systemctl start ssh 
sudo systemctl status ssh
sudo apt install apache2
sudo add-apt-repository ppa:ondrej/apache2 -y
sudo apt update
sudo apt install ufw
sudo ufw enable
sudo ufw allow from 52.214.221.145
sudo ufw allow from 52.50.207.205
sudo ufw allow from 34.255.188.27
sudo ufw allow from 109.0.28.108
sudo ufw allow from 52.211.149.81
sudo ufw allow from 52.49.122.126
sudo ufw allow from 54.76.16.128
sudo ufw allow from 94.185.65.65
echo -e "Header set Access-Control-Allow-Origin "https://apps.sogelink.fr"\nHeader set Access-Control-Allow-Origin "https://staging.apps.sogelink.fr"/nHeader set Access-Control-Allow-Origin "https://inte.apps.sogelink.fr"/n "> /httpd.conf

wget https://sourceforge.net/projects/geoserver/files/GeoServer/2.21.0/geoserver-2.21.0-bin.zip
mkdir /usr/share/geoserver
unzip -d /usr/share/geoserver/ geoserver-2.21.0-bin.zip
useradd -m -U -s /bin/false geoserver
chown -R geoserver:geoserver /usr/share/geoserver

echo -e "[Unit]\nDescription=GeoServer Service/nAfter=network.target/n[Service]/nType=simple/nUser=geoserver/nGroup=geoserver/n
Environment="GEOSERVER_HOME=/usr/share/geoserver"/n
ExecStart=/usr/share/geoserver/bin/startup.sh/nExecStop=/usr/share/geoserver/bin/shutdown.sh/n[Install]/nWantedBy=multi-user.target/n" > /usr/lib/systemd/system/geoserver.service

systemctl daemon-reload
systemctl enable --now geoserver
ss -antpl | grep 8080
systemctl status geoserver

