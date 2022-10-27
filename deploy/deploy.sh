#!/bin/bash
DOCKER_REPO="980318628917.dkr.ecr.us-east-1.amazonaws.com"
cd ..
sudo docker build -t aws-web -f docker/Dockerfile .
sudo docker tag aws-web $DOCKER_REPO/aws-web:latest
aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin $DOCKER_REPO
sudo docker push $DOCKER_REPO/aws-web:latest
