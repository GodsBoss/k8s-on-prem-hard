#!/bin/bash

for f in \
  kube-apiserver \
  kube-controller-manager \
  kube-scheduler \
  kubectl \
  kube-proxy \
  kubelet
do
  bin=tmp/${f}
  if [ \! -f ${bin} ]
  then
    wget --show-progress --https-only -O ${bin} "https://storage.googleapis.com/kubernetes-release/release/v1.10.1/bin/linux/amd64/${f}"
    chmod +x ${bin}
  fi
done
