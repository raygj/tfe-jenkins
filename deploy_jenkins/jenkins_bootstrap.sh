#!/bin/bash
#
# cd /tmp
# nano setup.sh
# chmod +x setup.sh
# ./setup.sh

# remove snap-installed docker, if it exists
snap remove docker

# install packages
sudo apt install docker openjdk-8-jdk unzip jq

# install and start jenkins
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins -y

sudo systemctl start jenkins

# sudo ufw allow 8080
sudo ufw allow 8800