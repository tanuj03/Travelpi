#!/bin/bash
clear

#This travel pi script install Comitup, wiregaurd Client, Network Manager, Docker, Portainer, Syncthing, Pi-apps on debian 11 

echo "*Make sure to run as root with sudo su*"
echo "*Some installation will reboot, run the script again to install everything*"
echo " "
echo " "

echo "Applications:"
echo "Comitup"
echo "Wireguard"
echo "Network_Manager"
echo "Docker"
echo "Portainer"
echo "Portainer_Agent"
echo "Syncthing"
echo "Pi-apps"
echo "Docker_compose"
read -p "Which application to install?: " app



function Comitup {
clear
echo "Installing Comitup" ; sleep 2
sudo apt update 
sudo apt-get install comitup -y
rm /etc/network/interfaces
systemctl mask dnsmasq.service
systemctl mask systemd-resolved.service
systemctl mask dhcpd.service
systemctl mask dhcpcd.service
systemctl mask wpa-supplicant.service
systemctl enable NetworkManager.service
touch /boot/ssh
clear
echo "Comitup Installed" ; sleep 2
echo ""
echo "" 
exec "$0" "$@"
}

function Wireguard {
clear
echo "Installing Wireguard" ; sleep 2
echo 'deb http://ftp.debian.org/debian buster-backports main' | sudo tee /etc/apt/sources.list.d/buster-backports.list
sudo apt update
sudo apt install wireguard -y
echo "Wireguard Installed" ; sleep 2
#creating key
wg genkey | sudo tee /etc/wireguard/privatekey | wg pubkey | sudo tee /etc/wireguard/publickey

echo "Creating Wireguard Config" ; sleep 2
#creating wiregard conf file
touch /etc/wireguard/wgvpn.conf
echo "#Copy and Paste Wireguard Peer Conf here, Ctrl+O, Ctrl+X" >> /etc/wireguard/wgvpn.conf
sudo nano /etc/wireguard/wgvpn.conf
echo "Wireguard Config created" ; sleep 2
sudo chmod 600 /etc/wireguard/{privatekey,wgvpn.conf}
sudo wg-quick up wgvpn
sudo systemctl enable wg-quick@wgvpn
clear
echo "Wireguard Installed" ; sleep 2
echo ""
echo "" 
exec "$0" "$@"
}

function Network {
clear
echo "Installing OpenVPN Network Manager" ; sleep 2
sudo apt install network-manager -y
sudo apt-get install openvpn network-manager-openvpn network-manager-openvpn-gnome network-manager-vpnc -y
echo "Network Manager is installed" ; sleep 2
clear
echo "Need to change to Network Manager" ; sleep 1
echo "Advanced Option>Network Config>Network Manager" ; sleep 5
sudo raspi-config
clear
echo "OpenVPN Network Manager Installed" ; sleep 2
echo ""
echo "" 
echo "Need to reboot"
echo "Rebooting in 5 seconds..."
sleep 5
sudo reboot
}

function Docker {
clear
echo "Installing Docker" ; sleep 2
curl -sSL https://get.docker.com | sh || error "Failed to install Docker."
sudo usermod -aG docker $USER || error "Failed to add user to the Docker usergroup."
clear
echo "Docker Installed" ; sleep 2
echo ""
echo "" 
echo "Need to reboot"
echo "Rebooting in 5 seconds..."
sleep 5
sudo reboot


}

function Portainer {
clear
echo "Installing Portainer" ; sleep 2
sudo docker pull portainer/portainer-ce:latest || error "Failed to pull latest Portainer docker image!"
sudo docker run -d -p 9000:9000 -p 9443:9443 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest || error "Failed to run Portainer docker image!"
clear
echo "Portainer Installed" ; sleep 2
echo "Portainer is avaiable on port 9000" ; sleep 2
echo ""
echo "" 
exec "$0" "$@"
}

function Portainer_Agent {
clear
echo "Installing Portainer Agent" ; sleep 2
docker run -d \
  -p 9001:9001 \
  --name portainer_agent \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/docker/volumes:/var/lib/docker/volumes \
  portainer/agent:2.18.1
clear
echo "Portainer Agent Installed" ; sleep 2
echo ""
echo "" 
exec "$0" "$@"
}


function Syncthing {
clear
echo "Installing Syncthing" ; sleep 2
echo "deb https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
sudo apt update
sudo apt install syncthing
sudo systemctl enable syncthing@pi.service #edit "pi" if the username is different
sudo systemctl start syncthing@pi.service #edit "pi" if the username is different
echo "Syncthing Installed" ; sleep 2
echo ""
echo "" 
exec "$0" "$@"
}

function Pi-apps {

clear
echo "Installing Pi-apps" ; sleep 2
wget -qO- https://raw.githubusercontent.com/Botspot/pi-apps/master/install | bash
echo "Portainer Pi-apps" ; sleep 2
echo ""
echo "" 
exec "$0" "$@"
}

function Docker_compose {

cd /home/pi/Travelpi
echo "Unzipping docker config files:"
unzip Travelpi_dockerconfig.zip -d /portainer/Files/AppData
echo "Starting docker compose"
docker compose up

}

if [ "$app" == "Comitup" ]; then
    Comitup

elif [ "$app" == "Wireguard" ]; then
    Wireguard   

elif [ "$app" == "Network_Manager" ]; then
    Network

elif [ "$app" == "Docker" ]; then
    Docker

elif [ "$app" == "Portainer" ]; then
    Portainer
    
elif [ "$app" == "Portainer_Agent" ]; then
    Portainer_Agent  
	
elif [ "$app" == "Syncthing" ]; then
    Syncthing
	
elif [ "$app" == "Pi-apps" ]; then
    Pi-apps

elif [ "$app" == "Docker_compose" ]; then
    Docker_compose 	
fi
