#!/bin/bash

hostname=$1
VAGRANT_HOME=/home/vagrant

apt-get install --yes socat conntrack

# Kubernetes hates swap.
swapoff -a

echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf

# CNI

mkdir -p \
  /opt/cni/bin \
  /etc/cni/net.d \

tar xvf ${VAGRANT_HOME}/cni-plugins.tgz -C /opt/cni/bin

# Containerd
tar xvf ${VAGRANT_HOME}/containerd.tar.gz -C /usr/local/
mv ${VAGRANT_HOME}/containerd.service /etc/systemd/system/

# runc
mv ${VAGRANT_HOME}/runc /usr/local/bin

# crictl
mv ${VAGRANT_HOME}/crictl /usr/local/bin
mv crictl.yaml /etc/crictl.yaml

# Kube binaries
for f in \
  kubectl \
  kube-proxy \
  kubelet
do
  mv ${VAGRANT_HOME}/${f} /usr/local/bin/
done

# Kube dirs
mkdir -p \
  /var/lib/kubelet \
  /var/lib/kube-proxy \
  /var/lib/kubernetes \
  /var/run/kubernetes \

# Kubelet

cp ${VAGRANT_HOME}/${hostname}-key.pem ${VAGRANT_HOME}/${hostname}.pem /var/lib/kubelet/
cp ${VAGRANT_HOME}/ca.pem /var/lib/kubernetes/
cp ${VAGRANT_HOME}/${hostname}.kubeconfig /var/lib/kubelet/kubeconfig
mv ${VAGRANT_HOME}/kubelet.service /etc/systemd/system/

# Kube proxy

cp ${VAGRANT_HOME}/kube-proxy.kubeconfig /var/lib/kube-proxy/kubeconfig
mv ${VAGRANT_HOME}/kube-proxy.service /etc/systemd/system/

# Start services

systemctl daemon-reload

systemctl enable \
  containerd \
  kubelet \
  kube-proxy \

systemctl start \
  containerd \
  kubelet \
  kube-proxy \
