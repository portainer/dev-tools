FROM ubuntu

RUN apt update && apt upgrade -y && apt install -y net-tools dnsutils iputils-ping curl