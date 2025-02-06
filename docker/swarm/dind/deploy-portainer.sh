#!/bin/bash

# set -x

if [[ "$#" -ne 1 ]]; then
  echo "Usage: $0 PORTAINER_IMAGE_REF"
  echo "Example"
  echo "   $0 portainerci/portainer-ee:develop"
  exit 1
fi

# portainerci/portainer-ee:develop -> portainerci\/portainer-ee:develop
escaped=${1////\\/}

#${1 // / / \\/}"
#  ^  ^ ^ ^  ^
#  |  | | |  |
#  |  | | |  string, '\' needs to be backslashed (\\/)
#  |  | | delimiter (/)
#  |  | pattern (/)
#  |  replace globally (//)
#  param 1 of script ($1)

# replace {{IMAGE}} in file then pipe to master-1 and deploy the resulting stack
sed "s/{{IMAGE}}/$escaped/g" portainer-agent-stack.yaml | docker exec -i master-1 sh -c "docker stack deploy -d -c - portainer"
