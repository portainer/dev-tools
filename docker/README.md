# Development

## Docker

### Requirements

- [docker-machine](https://docs.docker.com/machine/install-machine/)

You may find a preconfigured package for your distribution with apt/yum/yay/pacman/...
If not, follow the manual instruction on the last released version
https://github.com/docker/machine/releases/tag/v0.16.2

- ~~[docker-machine-ipconfig](https://github.com/fivestars/docker-machine-ipconfig)~~
  - You can find a copy of the script in `./docker-machine/` folder

### Notes

Alias `docker-machine` to `dm` and `docker-machine-ipconfig` to `dmip`. These aliases will be used in this README for simplicity.

### Basic command

1. `dm create <name>`: create a machine with name `<name>`
2. `dm ls`: list all existing machines with their state / driver / url / swarm status / docker version / errors (if any)
3. `dm rm <name>`: delete machine with name `<name>`
4. `dm`: will print help and all available commands

### Advanced commands

1. `dm create your-machine-name --virtualbox-boot2docker-url https://github.com/boot2docker/boot2docker/releases/download/v<DOCKER_VERSION>/boot2docker.iso`
Create a machine with a specific version of docker

Example for docker 18.09.3
`dm create your-machine-name --virtualbox-boot2docker-url https://github.com/boot2docker/boot2docker/releases/download/v18.09.3/boot2docker.iso`

Boot2docker ISOs supporting various docker versions can be found at https://github.com/troyxmccall/boot2docker
