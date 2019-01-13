#!/bin/bash

wget -q --show-progress --https-only --timestamping \
  -O tmp/etcd-v3.2.18-linux-amd64.tar.gz \
  "https://github.com/coreos/etcd/releases/download/v3.2.18/etcd-v3.2.18-linux-amd64.tar.gz"

tar -x -z -C tmp --strip-components 1 -f tmp/etcd-v3.2.18-linux-amd64.tar.gz etcd-v3.2.18-linux-amd64/etcd etcd-v3.2.18-linux-amd64/etcdctl
