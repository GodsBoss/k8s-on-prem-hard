#!/bin/bash

for instance in k8swrk1 k8swrk2 k8swrk3; do
  kubectl config set-cluster kubernetes \
    --certificate-authority=tmp/ca.pem \
    --embed-certs=true \
    --server=https://10.32.2.21:6443 \
    --kubeconfig=tmp/${instance}.kubeconfig

  kubectl config set-credentials system:node:${instance} \
    --client-certificate=tmp/${instance}.pem \
    --client-key=tmp/${instance}-key.pem \
    --embed-certs=true \
    --kubeconfig=tmp/${instance}.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes \
    --user=system:node:${instance} \
    --kubeconfig=tmp/${instance}.kubeconfig

  kubectl config use-context default --kubeconfig=tmp/${instance}.kubeconfig
done

kubectl config set-cluster kubernetes \
  --certificate-authority=tmp/ca.pem \
  --embed-certs=true \
  --server=https://10.32.2.21:6443 \
  --kubeconfig=tmp/kube-proxy.kubeconfig

kubectl config set-credentials kube-proxy \
  --client-certificate=tmp/kube-proxy.pem \
  --client-key=tmp/kube-proxy-key.pem \
  --embed-certs=true \
  --kubeconfig=tmp/kube-proxy.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes \
  --user=kube-proxy \
  --kubeconfig=tmp/kube-proxy.kubeconfig

kubectl config use-context default --kubeconfig=tmp/kube-proxy.kubeconfig
