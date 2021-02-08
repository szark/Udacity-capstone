#!/usr/bin/env bash
# This file tags and uploads an image to Docker Hub

# Assumes that an image is built via `run_docker.sh`

# Step 1:
# Create dockerpath
dockerpath=szark/udacity-proj4

# Step 2:  
# Authenticate & tag
echo "Docker ID and Image: $dockerpath"
docker login -u szark -p b1029834-035d-4c05-9eda-5f2e637d99b0 ## take it fromm variable 
docker image tag web_app:latest $dockerpath

# Step 3:
# Push image to a docker repository
docker push $dockerpath