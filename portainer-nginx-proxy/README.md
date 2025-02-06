Initial setup
* Add `portainer.local <YOUR_IP>` in `/etc/hosts`

Start the stack
* docker-compose up
* start your edge-agent following edge-agent-cmd-with-resolution.md
  * don't forget to add `--add-host=portainer.local:<YOUR_IP> \` parameter to your edge-agent `docker run...` command

Example
```
docker run -d \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/docker/volumes:/var/lib/docker/volumes \
  -v /:/host \
  -v portainer_agent_data:/data \
  --restart always \
  -e EDGE=1 \
  -e EDGE_ID=b66d3237-eae1-404a-bb9f-a024f5f116b3 \
  -e EDGE_KEY=aHR0cHM6Ly9wb3J0YWluZXIubG9jYWx8cG9ydGFpbmVyLmxvY2FsOjgwMDB8MTM6ZWU6ZmY6Zjg6YTQ6YmQ6ODA6NzM6NDU6NGU6YmI6ZDY6Yjk6MWQ6YTE6ZGJ8Mg \
  -e EDGE_INSECURE_POLL=1 \
  --add-host=portainer.local:192.168.1.20 \
  --name portainer_edge_agent \
  portainerci/agent:develop
```
