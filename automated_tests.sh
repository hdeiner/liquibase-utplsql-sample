#!/bin/bash

echo Stop all Docker containers
sudo -S <<< "password" docker stop $(sudo -S <<< "password" docker ps -aq)

echo Remove exited Docker containers
sudo docker ps --filter status=dead --filter status=exited -aq | xargs -r sudo docker rm -v

echo Remove unused Docker images
sudo -S <<< "password" docker images --no-trunc | grep '<none>' | awk '{ print $3 }' | xargs -r sudo docker rmi

echo Run the Docker image for Oracle 11g XE
sudo -S <<< "password" docker run -d -p 49160:22 -p 49161:1521 -p 49162:8080 alexeiled/docker-oracle-xe-11g

echo Pause a minute to allow Oracle to start up
sleep 60

echo Install utPLSQL
cd utPLSQL/source
sqlplus sys/oracle@localhost:49161/xe as sysdba @install_headless.sql
cd ../..

echo Install Schema, Test Data, PLSQL Code and utPLSQL to test with
liquibase --changeLogFile=db-changelog-PLSQL-and-unit-tests.xml update

echo Run the PLSQL unit tests
mkdir -p test_results
utplsql run system/oracle@localhost:49161:xe \
-source_path=demoPLSQL/source -test_path=demoPLSQL/test \
-f=ut_documentation_reporter  -c \
-f=ut_coverage_sonar_reporter -o=test_results/coverage.xml \
-f=ut_sonar_test_reporter     -o=test_results/test_results.xml \
--failure-exit-code=0