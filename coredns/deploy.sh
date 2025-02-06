#!/bin/bash

# docker run -d --rm --name coredns -p 53:53/udp -v ./Corefile:/etc/coredns/Corefile coredns/coredns
docker run -d --name coredns --volume=./:/root/ -p 53:53/udp coredns/coredns -conf /root/Corefile
