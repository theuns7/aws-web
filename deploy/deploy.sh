#!/bin/bash

cd ..
sudo docker build -t static-nginx -f docker/Dockerfile .
docker tag static-nginx ${DOCKER_REPO}/static-nginx:latest
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${DOCKER_REPO}
docker push ${DOCKER_REPO}/static-nginx:latest
