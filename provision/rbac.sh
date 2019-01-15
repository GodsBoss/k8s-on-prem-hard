#!/bin/bash

VAGRANT_HOME=/home/vagrant

sleep 10 # ...

kubectl apply -f ${VAGRANT_HOME}/kube-apiserver-to-kubelet-role.yaml
kubectl apply -f ${VAGRANT_HOME}/kube-apiserver-to-kubelet-binding.yaml
