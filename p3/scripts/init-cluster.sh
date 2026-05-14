#!/usr/bin/env sh

# update packages regestry
sudo apt-get update -y
sudo apt install curl -y

# install docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
rm get-docker.sh

# install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

# install k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# init cluster in containers, create single Node with Control and Worker same time
sudo k3d cluster create ipetrov -p "8080:80@loadbalancer" -p "8443:443@loadbalancer"
