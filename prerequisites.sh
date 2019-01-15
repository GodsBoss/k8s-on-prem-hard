#!/bin/bash

### Generate certicates 'n' keys

caconfig=pki/ca-config.json

cfssl gencert \
  -initca pki/ca-csr.json | cfssljson -bare tmp/ca

cfssl gencert \
  -ca=tmp/ca.pem \
  -ca-key=tmp/ca-key.pem \
  -config=${caconfig} \
  -profile=kubernetes \
  pki/admin-csr.json | cfssljson -bare tmp/admin

cfssl gencert \
  -ca=tmp/ca.pem \
  -ca-key=tmp/ca-key.pem \
  -config=${caconfig} \
  -profile=kubernetes \
  pki/kube-proxy-csr.json | cfssljson -bare tmp/kube-proxy

cfssl gencert \
  -ca=tmp/ca.pem \
  -ca-key=tmp/ca-key.pem \
  -config=${caconfig} \
  -hostname=10.32.2.11,10.32.2.12,10.32.2.13,10.32.2.21,10.10.0.1,127.0.0.1,kubernetes.default \
  -profile=kubernetes \
  pki/kubernetes-csr.json | cfssljson -bare tmp/kubernetes

for i in 1 2 3
do
  instance=k8swrk${i}
  ip=10.32.2.3${i}
  cfssl gencert \
    -ca=tmp/ca.pem \
    -ca-key=tmp/ca-key.pem \
    -config=${caconfig} \
    -hostname=${instance},${ip} \
    -profile=kubernetes \
    pki/${instance}-csr.json | cfssljson -bare tmp/${instance}
done

# We don't need those.
rm tmp/*.csr

### Get CNI plugins

wget -q --show-progress --https-only --timestamping \
  -O tmp/cni-plugins.tgz \
  "https://github.com/containernetworking/plugins/releases/download/v0.7.1/cni-plugins-amd64-v0.7.1.tgz"

### Get containerd binaries

wget -q --show-progress --https-only --timestamping \
  -O tmp/containerd.tar.gz \
  "https://github.com/containerd/containerd/releases/download/v1.1.0/containerd-1.1.0.linux-amd64.tar.gz"

### Get crictl

wget -q --show-progress --https-only --timestamping \
  -O tmp/crictl-v1.0.0-beta.0-linux-amd64.tar.gz \
  "https://github.com/kubernetes-incubator/cri-tools/releases/download/v1.0.0-beta.0/crictl-v1.0.0-beta.0-linux-amd64.tar.gz"

tar -x -z -C tmp -f tmp/crictl-v1.0.0-beta.0-linux-amd64.tar.gz

### Get etcd binaries

wget -q --show-progress --https-only --timestamping \
  -O tmp/etcd-v3.2.18-linux-amd64.tar.gz \
  "https://github.com/coreos/etcd/releases/download/v3.2.18/etcd-v3.2.18-linux-amd64.tar.gz"

tar -x -z -C tmp --strip-components 1 -f tmp/etcd-v3.2.18-linux-amd64.tar.gz etcd-v3.2.18-linux-amd64/etcd etcd-v3.2.18-linux-amd64/etcdctl

### Download Kube binaries

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

### Get runc binary

wget -q --show-progress --https-only --timestamping \
  -O tmp/runc \
  "https://github.com/opencontainers/runc/releases/download/v1.0.0-rc5/runc.amd64"

chmod +x tmp/runc

### Create kubeconfigs

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
