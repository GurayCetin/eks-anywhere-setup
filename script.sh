#!/bin/bash
echo "******************"
echo "storage increasing to 30gb"
echo "******************"
wget https://gist.githubusercontent.com/joozero/b48ee68e2174a4f1ead93aaf2b582090/raw/2dda79390a10328df66e5f6162846017c682bef5/resize.sh
sh resize.sh
echo "******************"
echo "storage is 30gb"
echo "******************"
echo "******************"
echo "kubectl downloading"
echo "******************"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(<kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
echo "******************"
echo "kubectl downloaded"
echo "******************"

echo "******************"
echo "eks-anywhere downloading"
echo "******************"
curl "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" --silent --location | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin/
export EKSA_RELEASE="0.7.0" OS="$(uname -s | tr A-Z a-z)" RELEASE_NUMBER=5
curl "https://anywhere-assets.eks.amazonaws.com/releases/eks-a/${RELEASE_NUMBER}/artifacts/eks-a/v${EKSA_RELEASE}/${OS}/amd64/eksctl-anywhere-v${EKSA_RELEASE}-${OS}-amd64.tar.gz" --silent --location | tar xz ./eksctl-anywhere
sudo mv ./eksctl-anywhere /usr/local/bin/
echo "******************"
echo "eks-anywhere downloaded"
echo "******************"

# echo "******************"
# echo "docker setup"
# echo "******************"
# sudo systemctl start docker
# sudo systemctl enable docker
# sudo usermod -aG docker ec2-user
# newgrp docker
# echo "******************"
# echo "docker setup done"
# echo "******************"

echo "******************"
echo "cluster creating in progress"
echo "******************"
CLUSTER_NAME=dev-cluster
export KUBECONFIG=${PWD}/${CLUSTER_NAME}/${CLUSTER_NAME}-eks-a-cluster.kubeconfig
eksctl anywhere generate clusterconfig $CLUSTER_NAME --provider docker > $CLUSTER_NAME.yaml
eksctl anywhere create cluster -f $CLUSTER_NAME.yaml
echo "******************"
echo "cluster created and kubeconfig done"
echo "******************"
