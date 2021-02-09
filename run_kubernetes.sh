#!/usr/bin/env bash

# This tags and uploads an image to Docker Hub

# Step 1:
# This is your Docker ID/path
# dockerpath=<>
dockerpath=szark/udacity-capstone

# Step 2
# Run the Docker Hub container with kubernetes
#docker stack deploy --namespace udacity --compose-file app.yml udacity
export dockerpath
kubectl create namespace capstone
envsubst < app_kube.yml | kubectl create -f -
#kubectl create -f app_kube.yml
# Step 3:
# List kubernetes pods
kubectl get pods -n capstone-ns

# Step 4:
# Forward the container port to a host
until kubectl get pods -n capstone-ns | grep Running; do sleep 5; done
kubectl port-forward -n capstone-ns deployment/capstone 8080:5000&
