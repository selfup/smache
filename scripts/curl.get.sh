#!/usr/bin/env bash

if [ "$HOST" == "" ]
then
  HOST=localhost
fi

if [ "$1" == "" ]
then
  echo 'PLEASE PROVIDE $1 FOR LB PORT'
else
# odd spacing for output
echo "
$(curl --fail --silent --show-error "$HOST:$1/api/?key=1")
$(curl --fail --silent --show-error "$HOST:$1/api/?key=2")
$(curl --fail --silent --show-error "$HOST:$1/api/?key=3")
$(curl --fail --silent --show-error "$HOST:$1/api/?key=4")
$(curl --fail --silent --show-error "$HOST:$1/api/?key=5")
$(curl --fail --silent --show-error "$HOST:$1/api/?key=6")
$(curl --fail --silent --show-error "$HOST:$1/api/?key=7")
"
fi
