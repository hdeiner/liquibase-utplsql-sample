#!/bin/bash

./start_oracle_in_docker_container.sh

echo Pause a minute to allow Oracle to start up
sleep 60

echo Install utPLSQL
cd utPLSQL/source
sqlplus sys/oracle@localhost:49161/xe as sysdba @install_headless.sql
cd ../..

echo Install Schema, Test Data, PLSQL Code and utPLSQL to test with
liquibase --changeLogFile=src/test/db/changelog-with-unit-tests.xml update

echo Run the PLSQL unit tests
mkdir -p test_results
utplsql run system/oracle@localhost:49161:xe \
-source_path=src/main/db -test_path=src/test/db \
-f=ut_documentation_reporter  -c \
-f=ut_coverage_sonar_reporter -o=test_results/sonar_coverage.xml \
-f=ut_sonar_test_reporter     -o=test_results/sonar_test.xml \
-f=ut_xunit_reporter          -o=test_results/xunit_results.xml \
--failure-exit-code=0