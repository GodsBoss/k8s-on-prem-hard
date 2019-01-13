#!/bin/bash

for f in \
  kube-apiserver \
  kube-controller-manager \
  kube-scheduler \
  kubectl
do
  bin=tmp/${f}
  wget --show-progress --https-only -O ${bin} "https://storage.googleapis.com/kubernetes-release/release/v1.10.1/bin/linux/amd64/${f}"
  chmod +x ${bin}
done
