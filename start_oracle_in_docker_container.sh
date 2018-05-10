#!/bin/bash

echo Stop all Docker containers
sudo -S <<< "password" docker stop $(sudo -S <<< "password" docker ps -aq)

echo Remove exited Docker containers
sudo docker ps --filter status=dead --filter status=exited -aq | xargs -r sudo docker rm -v

echo Remove unused Docker images
sudo -S <<< "password" docker images --no-trunc | grep '<none>' | awk '{ print $3 }' | xargs -r sudo docker rmi

echo Run the Docker image for Oracle 11g XE
sudo -S <<< "password" docker run -d -p 49160:22 -p 49161:1521 -p 49162:8080 alexeiled/docker-oracle-xe-11g