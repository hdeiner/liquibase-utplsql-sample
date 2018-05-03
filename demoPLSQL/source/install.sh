#!/bin/bash

set -ev

#sqlplus -L -S ${DB_USER}/${DB_PASS} <<SQL
sqlplus -L -S system/oracle@localhost:49161/xe <<SQL
whenever sqlerror exit failure rollback
whenever oserror  exit failure rollback

@award_bonus/employees_test.sql
@award_bonus/award_bonus.prc

@between_string/betwnstr.fnc

@remove_rooms_by_name/rooms.sql
@remove_rooms_by_name/remove_rooms_by_name.prc

exit
SQL
