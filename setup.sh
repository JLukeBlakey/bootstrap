#!/bin/bash

set -eo pipefail

#sudo apt-get update
#sudo apt-get upgrade
#
#sudo apt-get install python3-pip python3-venv --yes

### install syncthing
printf "\\nInstall syncthing?... (type yes)\\n"
read -r syncthing
if [[ $syncthing == "yes" ]];then
    sudo curl -fsSLo /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
    sudo apt-get update
    sudo apt-get install syncthing --yes
fi


### Kristoff
printf "\\nKristoff?... (type yes)\\n"
read -r kristoff
if [ "$kristoff" == "yes" ]; then
    sudo useradd kristoff --shell /bin/bash --create-home
    sudo su kristoff -c "ssh-keygen -f /home/kristoff/.ssh/id_rsa -P '' -C kristoff@$(hostname)"
    sudo cat /home/kristoff/.ssh/id_rsa.pub
    printf "\\n^ Add this public key to github. Press enter to continue...\\n"
    read -r key
    sudo su kristoff -l -c "ssh-keyscan github.com > .ssh/known_hosts && \
                            git clone git@github.com:JLukeBlakey/kristoff.git"
fi


### install docker
printf "\\nInstall docker?... (type yes)\\n"
read -r docker
if [[ $docker == "yes" ]]; then
    sudo apt-get install ca-certificates curl gnupg lsb-release --yes
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin --yes

    # test
    sudo docker run hello-world
fi


### install nomad
printf "\\nInstall nomad?... (type yes)\\n"
read -r nomad
if [[ $nomad == "yes" ]]; then
    sudo apt-get install gpg coreutils --yes
	curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
	echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
	sudo apt-get update
    sudo apt-get install nomad --yes
fi


### download websites
printf "\\nHost websites (requires kristoff, docker)?... (type yes)\\n"
read -r websites
if [ "$websites" == "yes" ]; then
    sudo apt-get install make \
         uidmap dbus-user-session fuse-overlayfs slirp4netns docker-ce-rootless-extras --yes # rootless docker
    sudo loginctl enable-linger kristoff
    sudo sysctl -w net.ipv4.ip_unprivileged_port_start=80
    sudo su kristoff -l -c "/usr/bin/dockerd-rootless-setuptool.sh install && \
                            systemctl --user start docker && \
                            systemctl --user enable docker && \
                            git clone git@github.com:JLukeBlakey/webserver.git && \
                            cd webserver && \
                            cp .versions.sample .versions && \
                            make start"
fi


### crypto
printf "\\nCryptobot?... (type yes)\\n"
read -r crypto
if [ "$crypto" == "yes" ]; then
    sudo useradd cryptobot --shell /bin/bash --create-home
    sudo su cryptobot -c "ssh-keygen -f /home/cryptobot/.ssh/id_rsa -P '' -C cryptobot@$(hostname)"
    sudo cat /home/cryptobot/.ssh/id_rsa.pub
    printf "\\n^ Add this public key to github. Press enter to continue...\\n"
    read key
    sudo su cryptobot -l -c "ssh-keyscan github.com > .ssh/known_hosts && \
                             git clone git@github.com:JLukeBlakey/crypto.git"
fi
