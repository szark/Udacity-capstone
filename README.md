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
.circleci - Circle CI directory
|   config.yml - Circle CI config file
└───ansible - ansible directory
|   |   configure-server.yml - ansible playbook to configure EC2 server
|   |   deploy-scripts.yml - ansible playbook to deploy application to Kubernetes 
|   |   inventory.txt - inventory file containing IP of EC2 instance
|   └───roles
|      └───configure-server
|      |   └───tasks
|      |           main.yml - ansible role file deployed with configure-server.yml playbook
|      └───deploy-scripts
|          └───tasks
|                  main.yml - ansible role file deployed with deploy-script.yml playbook
└───files
|       minikube.yml - Cloud Formation to deploy EC2 instance
templates
    kustomization.yml - kustomization file for config map deployment
    myweb.html - html file added to config map and being "web app"
Dockerfile - docker file to build application image
Makefile - make file 
README.md
requirements.txt - required python modules
web_app.py - main "web app" python file
```

