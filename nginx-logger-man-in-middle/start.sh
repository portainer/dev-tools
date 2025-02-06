#!/bin/bash

docker rm -f portainer-logger-proxy

rm -f ./logs/*

docker run -d \
  --name portainer-logger-proxy \
  -p 9010:9000 \
  -p 8010:8000 \
  -v ./nginx.conf:/etc/nginx/nginx.conf:ro \
  -v ./logs:/var/log/nginx \
  nginx:latest
