#!/bin/bash

token="ptr_PH7VJ1qiUzCb9IUVMJqbdUG+hDv2xwgrnU/9rOljnPk="
start=7990
end=10000
for i in in $(seq $start $end); do
  echo "creating env $i"

  curl -s -o /dev/null -X POST http://localhost:9000/api/endpoints \
    -H "X-API-KEY: ${token}" \
    -F "Name=agent-$i" \
    -F "EndpointCreationType=4" \
    -F "URL=http://192.168.1.20:9000" \
    -F "GroupID=$(($i % 5 + 2))" \
    -F "TagIds=[$(($i % 5 + 1))]" \
    -F "EdgeCheckinInterval=0" \
    -F "EdgeTunnelServerAddress=192.168.1.20:8000"
done
