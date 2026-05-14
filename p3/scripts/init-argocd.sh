#!/usr/bin/env sh

# prepare required namespaces
sudo kubectl create namespace argocd
sudo kubectl create namespace dev

# install argocd
sudo kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# bind cluster to git repo
sudo kubectl apply -f ./confs/deployment.yml

# expose argocd-server webui from pod to node
# sudo kubectl port-forward svc/argocd-server -n argocd 8181:443 > /dev/null 2>&1 &

# config argocd to work behind /argocd prefix and via port 80
sudo kubectl patch deployment argocd-server -n argocd --type='json' -p='[{"op": "add", "path": "/spec/template/spec/containers/0/command/-", "value": "--rootpath=/argocd"}]'
sudo kubectl patch deployment argocd-server -n argocd --type='json' -p='[{"op": "add", "path": "/spec/template/spec/containers/0/command/-", "value": "--insecure"}]'
