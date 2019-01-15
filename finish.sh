#!/bin/bash

### Configure host kubectl

kubectl config set-cluster kubernetes \
  --certificate-authority=tmp/ca.pem \
  --embed-certs=true \
  --server=https://10.32.2.21:6443

kubectl config set-credentials admin \
  --client-certificate=tmp/admin.pem \
  --client-key=tmp/admin-key.pem

kubectl config set-context kubernetes \
  --cluster=kubernetes \
  --user=admin

kubectl config use-context kubernetes

### Add weave

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&env.IPALLOC_RANGE=10.16.0.0/16"

### Add coredns

kubectl apply -f https://raw.githubusercontent.com/mch1307/k8s-thw/master/coredns.yaml
