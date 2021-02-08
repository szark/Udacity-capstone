#!/usr/bin/env bash

# This tags and uploads an image to Docker Hub

# Step 1:
# This is your Docker ID/path
# dockerpath=<>
dockerpath=szark/udacity-proj4

# Step 2
# Run the Docker Hub container with kubernetes
#docker stack deploy --namespace udacity --compose-file app.yml udacity
export dockerpath
kubectl create namespace udacity-ns
envsubst < app_kube.yml | kubectl create -f -
#kubectl create -f app_kube.yml
# Step 3:
# List kubernetes pods
kubectl get pods -n udacity-ns

# Step 4:
# Forward the container port to a host
kubectl port-forward -n udacity-ns deployment/udacity 8080:80&
