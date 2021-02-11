[![szark](https://circleci.com/gh/szark/Udacity-capstone.svg?style=svg)](https://app.circleci.com/pipelines/github/szark/Udacity-capstone)

## Project Overview

The application serves a Python flask app, which displays simple square, which color changes on each re-deployment. The color depends on CIRCLE_WORKFLOW_ID (${CIRCLE_WORKFLOW_ID:0:6}). The application is deployed to minikube cluster installed on EC2 instance and exposed to port 8080 of node. Deployment is fully automated via Circle CI.

### How deployment works

1. Build-code: In Python's virtual env are installed all dependencies with `make install`. Then Python and Docker file are verified with pylint and hadolint (`make lint`)
2. Build-docker: Docker image is being created out of the Dockerfile and uploaded to my repository (https://hub.docker.com/repository/docker/szark/udacity-capstone). The password to the repo is stored as variable in CircleCI.
3. Deploy-infrastructure: New EC2 instance is deployed with Cloud Formation script. The server has tag: **app: minikube**. On consecutive run, EC2 instance stays the same, as new app version is only deployed via Kubernetes.
4. Configure-server: An ansible job, which prepares EC2 instance by updating packages, installing docker, containerd, minikube, kubectl, Python's Openshift module and starts minikube.
5. Deploy-scripts: That job does ansible deployment. Before, it replaces color code of displayed square to ${CIRCLE_WORKFLOW_ID:0:6}, then ansible creates app directory, copy html with modified kode and kustomitation.yml, ensures namespace is created, deploys html as config map, creates kubernetes deployment, and port forward to port 8080.
6. Whenever new pipeline runs, color of square changes, change is applied to config map and pod is restarted. Because deployment has `imagePullPolicy: Always`, also if changes in image were applied, new version will be deployed.

### Included files
```
.circleci
|   config.yml
└───ansible
|   |   configure-server.yml
|   |   deploy-scripts.yml
|   |   inventory.txt
|   └───roles
|      └───configure-server
|      |   └───tasks
|      |           main.yml
|      └───deploy-scripts
|          └───tasks
|                  main.yml
└───files
|       minikube.yml
templates
    kustomization.yml
    myweb.html
Dockerfile
Makefile
README.md
requirements.txt
web_app.py
```

