#!/bin/bash

set -ev

#sqlplus -L -S ${DB_USER}/${DB_PASS} <<SQL
sqlplus -L -S system/oracle@localhost:49161/xe <<SQL
whenever sqlerror exit failure rollback
whenever oserror  exit failure rollback

@award_bonus/test_award_bonus.pks
@award_bonus/test_award_bonus.pkb

@between_string/test_betwnstr.pks
@between_string/test_betwnstr.pkb

@remove_rooms_by_name/test_remove_rooms_by_name.pks
@remove_rooms_by_name/test_remove_rooms_by_name.pkb

exit
SQL
