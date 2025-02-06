#!/bin/bash

docker exec master-1 docker stack rm portainer
docker exec master-1 docker volume rm portainer_portainer_data
