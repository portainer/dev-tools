This context exposes ports for agent deployment

1. Create the cluster: `./setup.sh create edge-agent`
2. Deploy Portainer: `./setup.sh portainer edge-agent`
3. Log into Portainer (`localhost:9060`) an add an edge-agent endpoint. URL MUST be `http://<HOME_NETWORK_IP>:9060` (generally `<HOME_NETWORK_IP` is `192.168.1.XXX`).
4. From Portainer, Linux > Kubernetes instructions, retrieve Edge ID and Edge Key.
Command should be like
```
curl https://downloads.portainer.io/portainer-edge-agent-setup.sh | sudo bash -s -- 1ee0e3da-68c9-4a6f-accc-b42c7ded434a aHR0cDovLzE5Mi4xNjguMS4xOTo5MDYwfDE5Mi4xNjguMS4xOTo4MDAwfDk5OmM2OjhiOmJjOjgzOjAwOmQwOjcyOjljOjkzOjQxOjkyOmQ5OjkxOjUwOjcxfDM
```
Here, retrieve
```
1ee0e3da-68c9-4a6f-accc-b42c7ded434a aHR0cDovLzE5Mi4xNjguMS4xOTo5MDYwfDE5Mi4xNjguMS4xOTo4MDAwfDk5OmM2OjhiOmJjOjgzOjAwOmQwOjcyOjljOjkzOjQxOjkyOmQ5OjkxOjUwOjcxfDM
```
5. Deploy the edge agent, providing the Edge ID and Key
`./configs/edge-agent/edge-agent-setup.sh EDGE_ID EDGE_KEY`
With my example:
`./configs/edge-agent/edge-agent-setup.sh 1ee0e3da-68c9-4a6f-accc-b42c7ded434a aHR0cDovLzE5Mi4xNjguMS4xOTo5MDYwfDE5Mi4xNjguMS4xOTo4MDAwfDk5OmM2OjhiOmJjOjgzOjAwOmQwOjcyOjljOjkzOjQxOjkyOmQ5OjkxOjUwOjcxfDM`
6. Wait a bit, edge should sync in less than 1 minute
7. You can check agent logs with
`kubectl --context kind-edge-agent -n portainer logs portainer-agent-xxxxxx` (use autocompletion to find portainer-agent pod name)
