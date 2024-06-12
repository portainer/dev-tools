## Setup

1. Create box with `vagrant up`
2. Start portainer
3. Create env -> provision microk8s

## UI provision steps

1. ssh credentials step
   1. credential name: whatever you want
   2. ssh username: `vagrant`
   3. ssh password: empty
   4. use key authentication: true
   5. Upload SSH key from computer:
      1. Run `vagrant ssh-config | grep IdentityFile` to locate the ssh key file
      2. Upload this file
      3. No passphrase
2. Create kube cluster step
   1. Name: whatever you want
   2. credentials: creds of previous step
   3. Control plane nodes: `192.168.99.254`
   4. Test connection should be ✅


## Notes
List of boxes can be found at https://app.vagrantup.com/ubuntu