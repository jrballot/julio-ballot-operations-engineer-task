#!/bin/bash

DBHOST=$1
DBPORT=$2
DBUSERNAME=$3
DBPASSWORD=$4
DBDATABASE=$5

PSQL=$(which psql)

if [ -z $PSQL ]; then
  echo "ERROR: psql not found on your current path. "
  exit 1 
fi	

$PSQL  "postgresql://$DBUSERNAME:$DBPASSWORD@$DBHOST:$DBPORT" -c "drop database rates;"
$PSQL  "postgresql://$DBUSERNAME:$DBPASSWORD@$DBHOST:$DBPORT" -c "create database rates;"
$PSQL  "postgresql://$DBUSERNAME:$DBPASSWORD@$DBHOST:$DBPORT/rates" < db/rates.sql

