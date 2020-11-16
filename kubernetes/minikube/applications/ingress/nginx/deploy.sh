#!/bin/bash
CONTEXT="minikube"

minikube addons enable ingress
while : ; do
    sleep 2
    kubectl --context $CONTEXT apply -f example-ingress.yaml
    [[ `echo $?` -ne 0 ]] || break
done

kubectl --context $CONTEXT --namespace example-ingress create deployment web --image=gcr.io/google-samples/hello-app:1.0
kubectl --context $CONTEXT --namespace example-ingress expose deployment web --type=NodePort --port=8080
kubectl --context $CONTEXT --namespace example-ingress create deployment web2 --image=gcr.io/google-samples/hello-app:2.0
kubectl --context $CONTEXT --namespace example-ingress expose deployment web2 --port=8080 --type=NodePort