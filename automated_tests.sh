#!/bin/bash

echo Stop all Docker containers
echo password | sudo -S docker stop $(sudo docker ps -aq)

echo Remove exited Docker containers
echo password | sudo -S docker ps --filter status=dead --filter status=exited -aq | xargs -r sudo docker rm -v

echo Remove unused Docker images
echo password | sudo -S docker images --no-trunc | grep '<none>' | awk '{ print $3 }' | xargs -r sudo docker rmi

echo Run the Docker image for Oracle 11g XE
echo password | sudo -S docker run -d -p 49160:22 -p 49161:1521 -p 49162:8080 alexeiled/docker-oracle-xe-11g

echo Wait for Oracle to start up
sleep 60

echo Install Schema and Test Data
liquibase update

echo Install utPLSQL
cd utPLSQL/source
sqlplus sys/oracle@localhost:49161/xe as sysdba @install_headless.sql
cd ../..

echo Install PLSQL source to test
sqlplus -L -S system/oracle@localhost:49161/xe <<SQL
whenever sqlerror exit failure rollback
whenever oserror  exit failure rollback

@demoPLSQL/source/award_bonus/employees_test.sql
@demoPLSQL/source/award_bonus/award_bonus.prc

@demoPLSQL/source/between_string/betwnstr.fnc

@demoPLSQL/source/remove_rooms_by_name/rooms.sql
@demoPLSQL/source/remove_rooms_by_name/remove_rooms_by_name.prc

exit
SQL

echo Install PLSQL unit tests
sqlplus -L -S system/oracle@localhost:49161/xe <<SQL
whenever sqlerror exit failure rollback
whenever oserror  exit failure rollback

@demoPLSQL/test/award_bonus/test_award_bonus.pks
@demoPLSQL/test/award_bonus/test_award_bonus.pkb

@demoPLSQL/test/between_string/test_betwnstr.pks
@demoPLSQL/test/between_string/test_betwnstr.pkb

@demoPLSQL/test/remove_rooms_by_name/test_remove_rooms_by_name.pks
@demoPLSQL/test/remove_rooms_by_name/test_remove_rooms_by_name.pkb

exit
SQL

echo Run the PLSQL unit tests
utplsql run system/oracle@localhost:49161:xe \
-source_path=demoPLSQL/source -test_path=demoPLSQL/test \
-f=ut_documentation_reporter  -c \
-f=ut_coverage_sonar_reporter -o=coverage.xml \
-f=ut_sonar_test_reporter     -o=test_results.xml \
--failure-exit-code=0