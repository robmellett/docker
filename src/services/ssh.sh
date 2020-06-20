#!/bin/sh

echo ">>> Setting up SSH..."

rm -f /etc/service/sshd/down
ssh-keygen -P "" -t dsa -f /etc/ssh/ssh_host_dsa_key

# You can connect to the machine with:
#   ssh -i "~/.ssh/docker-dev" root@172.24.0.2 -p 2222

#   ssh -i "~/.ssh/docker-dev" root@127.0.0.1 -p 2222