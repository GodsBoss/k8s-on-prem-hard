#!/bin/bash

wget -q --show-progress --https-only --timestamping \
  -O tmp/containerd-1.1.0.linux-amd64.tar.gz \
  "https://github.com/containerd/containerd/releases/download/v1.1.0/containerd-1.1.0.linux-amd64.tar.gz"

mkdir -p tmp/containerd

tar -v -x -z -C tmp/containerd --strip-components 1 -f tmp/containerd-1.1.0.linux-amd64.tar.gz
