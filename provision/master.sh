#!/bin/bash

VAGRANT_HOME=/home/vagrant

# Install Kube binaries.
for f in \
  kube-apiserver \
  kube-controller-manager \
  kube-scheduler \
  kubectl
do
  mv ${VAGRANT_HOME}/${f} /usr/local/bin/
done

# Install TLS files.
mkdir -p /var/lib/kubernetes/
for f in \
  ca.pem ca-key.pem \
  kubernetes-key.pem \
  kubernetes.pem \
  encryption-config.yaml
do
  cp ${VAGRANT_HOME}/${f} /var/lib/kubernetes/
done

# Install service files.
for f in \
  kube-apiserver.service \
  kube-scheduler.service \
  kube-controller-manager.service
do
  mv ${VAGRANT_HOME}/${f} /etc/systemd/system
done

# Start Kube services.

systemctl daemon-reload

systemctl enable \
  kube-apiserver \
  kube-controller-manager \
  kube-scheduler \

systemctl start \
  kube-apiserver \
  kube-controller-manager \
  kube-scheduler \
