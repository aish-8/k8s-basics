#!/bin/bash
set -e

echo "Updating system..."
sudo apt update

echo "Installing containerd..."
sudo apt install -y containerd

echo "Configuring containerd..."
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml

# Fix for Kubernetes
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd

echo "Installing Kubernetes dependencies..."
sudo apt install -y apt-transport-https ca-certificates curl gpg

echo "Creating keyring directory..."
sudo mkdir -p /etc/apt/keyrings

echo "Adding Kubernetes GPG key..."
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | \
sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "Adding Kubernetes repository..."
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /" | \
sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "Updating apt..."
sudo apt update

echo "Installing kubelet kubeadm kubectl..."
sudo apt install -y kubelet kubeadm kubectl

echo "Holding versions..."
sudo apt-mark hold kubelet kubeadm kubectl

echo "Setup completed!"
