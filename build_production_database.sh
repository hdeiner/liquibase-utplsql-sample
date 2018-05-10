#!/bin/bash

./docker_start_oracle_production_database.sh

echo Pause a minute to allow Oracle to start up
sleep 60

echo Build the production database
liquibase --changeLogFile=src/main/db/changelog.xml --url=jdbc:oracle:thin:@localhost:49261/xe update