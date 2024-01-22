#!/bin/bash

function cmd() {
  until vagrant ssh -c "$1"; do
    echo ...
    sleep 1
  done
}

# create box
echo "Creating vagrant box"
vagrant up
echo "Done."

# update/upgrade ubuntu && reboot
echo "Updating ubuntu..."
cmd "sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y && sudo reboot"
echo "Done."

# install microk8s && reboot
echo "Installing microk8s..."
cmd "sudo snap install microk8s --classic && sudo reboot"
echo "Done."

# adding vagrant user to microk8s group
echo "Adding vagrant user to microk8s group"
cmd "sudo usermod -a -G microk8s vagrant && newgrp microk8s"
echo "Done."

# enable microk8s addons
echo "Enabling microk8s required addons"
cmd "microk8s enable dns"
cmd "microk8s enable ha-cluster"
cmd "microk8s enable ingress"
cmd "microk8s enable metrics-server"
cmd "microk8s enable rbac"
cmd "microk8s enable hostpath-storage"
echo "Done."

# deploy portainer
echo "Deploying Portainer"
cmd "microk8s enable community && microk8s enable portainer"
echo "Done."

# retrieve portainer IP
echo "Portainer is running at https://192.168.99.254:30779"
echo "End of script"
