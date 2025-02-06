#!/bin/bash

set -a
source .env
set +a

# # name of the target docker-machine VM
DM_NAME=${DM_NAME:-"swarm"}
# CE image to deploy initially
CE_IMAGE=${CE_IMAGE:-"portainerci/portainer-ce:local"}
# agent image to deploy initially
AGENT_IMAGE=${AGENT_IMAGE:-"portainerci/agent:develop"}
# source EE image (existing) to use as next
EE_SOURCE_IMAGE=${EE_SOURCE_IMAGE:-"portainerci/portainer-ee:develop"}
# next EE image reference (ref of the CE to EE upgrade)
EE_NEXT_IMAGE=${EE_NEXT_IMAGE:-"portainer/portainer-ee:2.22.0"}

cat <<EOF
Using environment
- DM_NAME = ${DM_NAME}
- CE_IMAGE = ${CE_IMAGE}
- AGENT_IMAGE = ${AGENT_IMAGE}
- EE_SOURCE_IMAGE = ${EE_SOURCE_IMAGE}
- EE_NEXT_IMAGE = ${EE_NEXT_IMAGE}
EOF

## remove previous docker-machine VM
echo "  >>  Removing previous ${DM_NAME} env"
docker-machine rm -y "${DM_NAME}"

## create docker-machine VM
echo "  >>  Creating ${DM_NAME} env"
docker-machine create "${DM_NAME}" --virtualbox-boot2docker-url https://github.com/troyxmccall/boot2docker/releases/download/v27.0.2/boot2docker.iso

## init swarm
echo "  >>  Initializing swarm cluster"
IP=$(docker-machine ls --filter name="${DM_NAME}" -f {{.URL}} | cut -d / -f 3 | cut -d : -f 1)
docker-machine ssh "${DM_NAME}" "docker swarm init --advertise-addr ${IP}"

## pull and tag next image in VM
if [[ $EE_SOURCE_IMAGE == *:local ]]; then
echo "  >>  Uploading the EE image and making it available for the upgrade"
docker save "${EE_SOURCE_IMAGE}" | docker-machine ssh "${DM_NAME}" "docker load"
docker-machine ssh "${DM_NAME}" "docker tag ${EE_SOURCE_IMAGE} ${EE_NEXT_IMAGE}"
else
echo "  >>  Pulling the EE image and making it available for the upgrade"
docker-machine ssh "${DM_NAME}" "docker pull ${EE_SOURCE_IMAGE} && docker tag ${EE_SOURCE_IMAGE} ${EE_NEXT_IMAGE}"
fi

## upload local CE image or pull
if [[ $CE_IMAGE == *:local ]]; then
echo "  >>  Uploading the CE image"
docker save "${CE_IMAGE}" | docker-machine ssh "${DM_NAME}" "docker load"
else
echo "  >>  Pulling the ${CE_IMAGE} image"
docker-machine ssh "${DM_NAME}" "docker pull ${CE_IMAGE}"
fi

YAML_TEMPLATE="$(dirname "$0")/local-stack.yml"
TMP_DIR="/tmp"
CE_COMPOSE="ce_compose.yaml"
# transform template and save it to temp folder
echo "  >>  Generating CE compose file from template"
cat "${YAML_TEMPLATE}" | sed "s|CE_IMAGE%%%|${CE_IMAGE}|g" | sed "s|AGENT_IMAGE%%%|${AGENT_IMAGE}|g" >"${TMP_DIR}/${CE_COMPOSE}"

## upload CE compose file to VM
echo "  >>  Uploading CE compose file to ${DM_NAME} env"
docker-machine scp "${TMP_DIR}/${CE_COMPOSE}" "${DM_NAME}":~

## create tmp directories in VM for data binding
echo "  >>  Creating tmp directories in ${DM_NAME} env for data binding"
docker-machine ssh "${DM_NAME}" "mkdir ~/agent_tmp ~/portainer_tmp"

## start CE
echo "  >>  Deploying CE compose stack"
docker-machine ssh "${DM_NAME}" "docker stack deploy -c ~/${CE_COMPOSE} portainer"

## print URL
echo "  >>  Cluster running at http://${IP}:9000"
