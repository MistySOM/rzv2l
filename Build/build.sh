#!/bin/bash
NAME="rzv2l_vlp_v3.0.4"
if [ "$1" == "-b" ]; then
	IMAGE_NAME="$(whoami)-${NAME}_$(git branch --show-current)"
else
	IMAGE_NAME="$(whoami)-${NAME}"
fi
docker build -t ${IMAGE_NAME}:latest .
(docker images | grep "^<none" | awk '{print $3}' | xargs docker rmi) || :
