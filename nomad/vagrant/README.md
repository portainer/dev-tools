### Create / start the env

```sh
vagrant up
```

### Stop the env

```sh
vagrant halt
```

### Start nomad (keeps the logs but puts the execution in a subshell)

```sh
./nomad_start.sh
```

### Deploy the agent using ssh

```sh
vagrant ssh
*in ssh
<execute the command given by Portainer to start the agent>
```

For example while in ssh

```sh
curl https://downloads.portainer.io/ee2-16/portainer-edge-agent-nomad-setup.sh | bash -s -- "" "87143d48-9780-44dc-9d8c-0556d2554689" "aHR0cDovLzE5Mi4xNjguMS4yMDo5MDAwfDE5Mi4xNjguMS4yMDo4MDAwfDM5OjMwOmVlOjcxOmQyOjU1Ojk3OmIzOjNjOjZjOmY0OjU1OmMzOjQ0OmE3OjJlfDM" "1" "" "" "false"
```


### Deploy the latest develop agent using ssh
```sh
./deploy_agent.sh '[agent args given by Portainer]'
```

/!\ DO NOT FORGET THE SURROUNDING SINGLE QUOTES /!\

For example (same params as above)

```sh
./develop.sh '"" "87143d48-9780-44dc-9d8c-0556d2554689" "aHR0cDovLzE5Mi4xNjguMS4yMDo5MDAwfDE5Mi4xNjguMS4yMDo4MDAwfDM5OjMwOmVlOjcxOmQyOjU1Ojk3OmIzOjNjOjZjOmY0OjU1OmMzOjQ0OmE3OjJlfDM" "1" "" "" "false"'
```