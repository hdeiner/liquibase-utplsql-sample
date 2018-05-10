#!/bin/bash

./start_oracle_in_docker_container.sh

echo Pause a minute to allow Oracle to start up
sleep 60

echo Build the production database
liquibase --changeLogFile=src/main/db/changelog.xml update