#!/bin/bash

set -e

DOCKER_IMAGE_NAME=nagios
DOCKER_CONTAINER_NAME=nagiosgraph

docker build -t "${DOCKER_IMAGE_NAME}" .

docker images

docker run -itd --name "${DOCKER_CONTAINER_NAME}" -p 4000:80 -v /mnt:/mnt -t "${DOCKER_IMAGE_NAME}"

docker ps -a

