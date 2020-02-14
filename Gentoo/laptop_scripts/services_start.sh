#!/bin/bash

. ./_error_handling.sh

if [ "$(getenforce)" == "Enforcing" ]; then
  echo "Unable to run with SELinux in enforcing mode..."
  exit 1
fi

docker run -d --rm --name gentoo_nfs --privileged -v $(pwd):/setup_scripts \
  -p 2049:2049 -e SHARED_DIRECTORY=/setup_scripts itsthenetwork/nfs-server-alpine:latest

docker run -d --rm --name gentoo_binhost -p 8200:80 \
  -v $(pwd)/cache:/usr/share/nginx/html:ro nginx:alpine

sudo iptables -A INPUT -m tcp -p tcp --dport 2049 -i virbr0 -j ACCEPT
sudo iptables -A INPUT -m tcp -p tcp --dport 8200 -i virbr0 -j ACCEPT
