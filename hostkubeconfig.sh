#!/bin/bash

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
