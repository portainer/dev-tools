#!/bin/bash

# HOW TO USE FROM INSIDE VAGRANT (while in vagrant ssh)
# /vagrant/redeploy_portainer.sh

# or from host
# vagrant ssh -c "/vagrant/redeploy_portainer.sh"

microk8s kubectl delete namespace portainer && microk8s disable portainer && microk8s enable portainer