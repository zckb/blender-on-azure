#!/bin/bash

userName=$1
repositoryUrl="https://raw.githubusercontent.com/huzferd/deploy-to-azure/master/config/"

log() {
    echo "[post-install] $1"
    date
}

log "Starting post install on pid $$"

log "Start removing locks"
sudo apt-get update -y
ps axf | grep apt | grep -v grep | awk '{print "sudo kill -9 " $1}' | sh
sudo rm /var/lib/apt/lists/* -vf
sudo rm /var/lib/apt/lists/lock -f
sudo rm /var/cache/apt/archives/lock -f
sudo rm /var/lib/dpkg/lock -f
sudo dpkg --configure -a
sudo apt-get update -y
sudo apt-get -f install -y
log "Completed the removal of locks"

log "Update package database"
sudo apt-get update -y
# sudo apt-get upgrade -y

log "Install xRDP"
sudo apt-get install xrdp -y
sudo ufw allow 3389/tcp

# Install XFCE
# sudo apt-get install xfce4 -y

log "Configure XFCE"
echo xfce4-session >~/.xsession
sudo sed -i.bak '/fi/a startxfce4\n' /etc/xrdp/startwm.sh
sudo /etc/init.d/xrdp start
sudo service xrdp restart

log "Install Blender"
sudo apt-get install blender -y

log "Configure Blender's preferences"
wget $repositoryUrl/userpref.tar
prefPath="/home/$userName/.config/blender/2.76/config"
tar -xvf userpref.tar
sudo mkdir -p $prefPath
sudo cp userpref.blend $prefPath
sudo chmod -R 775 /home/$userName/.config/*
sudo chown -R $userName:$userName /home/$userName/.config/*
sudo sed -i.bak 's/#elif __CUDA_ARCH__ == 500 || __CUDA_ARCH__ == 520/#elif __CUDA_ARCH__ >= 500/g' /usr/share/blender/scripts/addons/cycles/kernel/kernels/cuda/kernel.cu

log "Install UnZip"
sudo apt-get install unzip -y

log "Download Blender example"
wget https://download.blender.org/demo/test/BMW27_2.blend.zip
unzip ./BMW27_2.blend.zip
bldPath="/home/$userName/blender-example"
sudo mkdir $bldPath
sudo cp ./bmw27/* $bldPath
sudo chmod -R 777 $bldPath
sudo chown -R :users $bldPath

log "Restart services"
sudo service xrdp restart
sudo service ssh restart

log "Completed post install on pid $$"
