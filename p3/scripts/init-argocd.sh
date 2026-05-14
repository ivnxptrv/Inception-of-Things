#!/usr/bin/env sh

# prepare required namespaces
sudo kubectl create namespace argocd
sudo kubectl create namespace dev

# install argocd
sudo kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# wait when argocd start to work
sudo kubectl -n argocd wait --for=condition=Established --timeout=120s \
  crd/applications.argoproj.io crd/appprojects.argoproj.io
sudo kubectl -n argocd rollout status deploy/argocd-server --timeout=180s

# bind cluster to git repo
sudo kubectl apply -f ../confs/deployment.yml

# config argocd to work behind /argocd prefix
sudo kubectl -n argocd patch configmap argocd-cmd-params-cm \
  --type merge -p '{"data":{"server.insecure":"true","server.rootpath":"/argocd"}}'
sudo kubectl -n argocd rollout restart deploy argocd-server
