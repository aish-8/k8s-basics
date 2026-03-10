#!/bin/bash
set -e

echo "Disabling swap..."
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

echo "Initializing Kubernetes master..."
sudo kubeadm init --pod-network-cidr=192.168.0.0/16

echo "Configuring kubectl for ubuntu user..."
mkdir -p $HOME/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $USER:$USER $HOME/.kube/config

echo "Installing Calico network plugin..."
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.3/manifests/calico.yaml

echo "Waiting for nodes to be ready..."
sleep 30

echo "Cluster status:"
kubectl get nodes

echo "Master setup completed!"
