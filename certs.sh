#!/bin/bash

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
