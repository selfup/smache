#!/usr/bin/env bash

if [ "$HOST" == "" ]
then
  HOST=localhost
fi

if [ "$1" == "" ] || [ "$2" == "" ]
then
  echo 'PLEASE PROVIDE $1 and $2 FOR PORTS'
else
# odd spacing for output
echo "
$(curl --fail --silent --show-error "$HOST:$1/api/?key=1")
$(curl --fail --silent --show-error "$HOST:$2/api/?key=2")
"
fi
