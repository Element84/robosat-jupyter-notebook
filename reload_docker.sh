#!/bin/bash
OS=$1
if [[ "$#" != 1 ]] || [[ "$OS" != 'mac' && "$OS" != 'ubuntu' ]]; then
  echo "Must supply OS where this is running ['mac','ubuntu']. E.g., './reload_docker.sh mac'"
  exit 1
fi

echo "git pulling for the latest"
git pull

echo 'Killing the currently running docker, if there is one'
RUNNING_DOCKER=`docker ps --filter ancestor=robosat-jupyter --format={{.ID}}`
if [[ -z "$RUNNING_DOCKER" ]]; then
	echo "No robosat-jupyter docker image running, continuing"
else
	echo "Killing running robosat-jupyter docker with ID: $RUNNING_DOCKER"
	docker kill "$RUNNING_DOCKER"
fi

echo "Rebuilding image from source"
docker build -t robosat-jupyter .

if [[ "$OS" == 'mac' ]]; then
  echo "Running local for a mac (no nvida drivers)"
  docker run -d -p 8888:8888 -p 5000:5000 -e DESIRED_ZOOM_LEVEL=19 -e PUBLIC_IP=127.0.0.1 -t robosat-jupyter jupyter notebook --ip=0.0.0.0 --allow-root
elif [[ "$OS" == 'ubuntu' ]]; then
  echo "Running local for an EC2 ubuntu image with nvida drivers"
  docker run -d --runtime=nvidia -e DESIRED_ZOOM_LEVEL=19 -e PUBLIC_IP=127.0.0.1 -v /home/ubuntu/robosat/container_mount:/app/container_mount -v /home/ubuntu/robosat_container_files:/app/robosat_container_files -p 8888:8888 -p 5000:5000 -t robosat-jupyter jupyter notebook --ip=0.0.0.0 --allow-root
else
  echo "OS $OS is not supported"
  exit 1
fi

NEW_DOCKER=`docker ps --filter ancestor=robosat-jupyter --format={{.ID}}`
sleep 5
echo "New Jupyter Token: "
docker logs "$NEW_DOCKER" | grep token | tail -1 | awk -F= '{print $2}'

