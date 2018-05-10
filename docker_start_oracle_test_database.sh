#!/bin/bash

echo Run the Docker image for Oracle 11g XE test database
sudo -S <<< "password" docker run -d -p 49160:22 -p 49161:1521 -p 49162:8080 alexeiled/docker-oracle-xe-11g