#!/bin/bash

wget -q --show-progress --https-only --timestamping \
  -O tmp/runc \
  "https://github.com/opencontainers/runc/releases/download/v1.0.0-rc5/runc.amd64"

chmod +x tmp/runc
