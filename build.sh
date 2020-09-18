#!/usr/bin/env bash

# Test Docker has been configured locally
docker login

# Build CI Images Locally | -f Dockerfile
docker build -f ./src/Dockerfiles/Base.Dockerfile -t robmellett/base:latest .
# docker push docker.io/robmellett/base:latest

# Build LEMP Image
docker build -f ./src/Dockerfiles/Web.Dockerfile  -t robmellett/lemp:7.4 .
# docker push docker.io/robmellett/lemp:7.4

# Build Node Image
docker build -f ./src/Dockerfiles/Node.Dockerfile -t robmellett/node:latest .
# docker push docker.io/robmellett/node:latest


# Test Images Locally
# docker run robmellett/base
# docker container ls --latest
# docker exec -it <container_id> bash

# Clear all Images
# docker rmi $(docker images -q) --force