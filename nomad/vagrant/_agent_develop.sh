curl https://downloads.portainer.io/ee2-16/portainer-edge-agent-nomad-setup.sh | \
sed 's/# try to retrieve node info to get datacenter info/# try to retrieve node info to get datacenter info\ninfo "Replacing agent version"\nsed -i "s\/portainerci\\\/agent:2.15\/portainerci\\\/agent:pr387\/" $job_file_name/' | \
bash -s -- 