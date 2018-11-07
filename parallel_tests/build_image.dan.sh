#! /bin/bash

if [ -n "$1" ]; then 
  DOCKVAR="$1"
  echo >&2 BUILDING IMAGE
  docker build --build-arg docker_var=$DOCKVAR -f Dockerfile.dan.$1 -t irods_test_env_$1 .
else
  echo >&2 "Please add an argument eg. 42s"
  :
fi
