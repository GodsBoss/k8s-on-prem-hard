#!/bin/bash

wget -q --show-progress --https-only --timestamping \
  -O tmp/cni-plugins-amd64-v0.7.1.tgz \
  "https://github.com/containernetworking/plugins/releases/download/v0.7.1/cni-plugins-amd64-v0.7.1.tgz"
