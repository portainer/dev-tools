#!/bin/bash

vagrant ssh -c "microk8s kubectl get pods -n portainer -o yaml | sudo microk8s kubectl replace --force -f -"