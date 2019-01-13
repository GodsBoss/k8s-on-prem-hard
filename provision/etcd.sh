#!/bin/bash

VAGRANT_HOME=/home/vagrant

# Binaries
cp ${VAGRANT_HOME}/etcd /usr/local/bin/
cp ${VAGRANT_HOME}/etcdctl /usr/local/bin/

# Used by etcd.
mkdir -p /var/lib/etcd

# Copy certs.
mkdir -p /etc/etcd
cp ${VAGRANT_HOME}/ca.pem /etc/etcd/
cp ${VAGRANT_HOME}/kubernetes.pem /etc/etcd/
cp ${VAGRANT_HOME}/kubernetes-key.pem /etc/etcd/

# Install daemon
cp ${VAGRANT_HOME}/etcd.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable etcd
systemctl start etcd
