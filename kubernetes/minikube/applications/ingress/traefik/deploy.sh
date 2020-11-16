#!/bin/bash

CONTEXT="minikube"

kubectl --context $CONTEXT replace --force -f 1.sa-cr-crb.yaml

kubectl --context $CONTEXT replace --force -f 2.deployment.yaml
kubectl --context $CONTEXT --namespace=kube-system get pods

kubectl --context $CONTEXT replace --force -f 3.svc.yaml
kubectl --context $CONTEXT describe svc traefik-ingress-service --namespace=kube-system

kubectl --context $CONTEXT replace --force -f 4.webui-svc.yaml
kubectl --context $CONTEXT describe svc traefik-web-ui --namespace=kube-system

kubectl --context $CONTEXT replace --force -f 5.ingress.yaml
