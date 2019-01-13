#!/bin/bash

wget -q --show-progress --https-only --timestamping \
  -O tmp/crictl-v1.0.0-beta.0-linux-amd64.tar.gz \
  "https://github.com/kubernetes-incubator/cri-tools/releases/download/v1.0.0-beta.0/crictl-v1.0.0-beta.0-linux-amd64.tar.gz"

tar -x -z -C tmp -f tmp/crictl-v1.0.0-beta.0-linux-amd64.tar.gz
