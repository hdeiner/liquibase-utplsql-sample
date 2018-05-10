#!/bin/bash

echo Run the Docker image for Oracle 11g XE production database
sudo -S <<< "password" docker run -d -p 49260:22 -p 49261:1521 -p 49262:8080 alexeiled/docker-oracle-xe-11g