#!/bin/bash

# Install HAProxy
add-apt-repository ppa:vbernat/haproxy-1.8
apt-get update
apt-get install --yes haproxy=1.8.16-2ppa1~xenial

# Add 'our' configuration.
echo '' >> /etc/haproxy/haproxy.cfg
cat /home/vagrant/haproxy.cfg-addendum >> /etc/haproxy/haproxy.cfg

# Start service
service haproxy enable
service haproxy start