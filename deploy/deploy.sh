#!/bin/bash

cd ..
sudo docker build -t static-nginx -f docker/Dockerfile .
aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${DOCKER_REPO}
docker push ${DOCKER_REPO}/${JOB_NAME}:latest
