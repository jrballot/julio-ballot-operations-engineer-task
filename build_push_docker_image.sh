#!/bin/bash

ECRREPO=$1


cd rates/
docker build -t operations-task-image .
docker tag operations-task-image $ECRREPO:latest
aws ecr get-login-password  > docker-pass
docker login -u AWS $ECRREPO --password-stdin < docker-pass
docker push $ECRREPO:latest
