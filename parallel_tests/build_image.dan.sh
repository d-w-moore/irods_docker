#! /bin/bash

usage(){
  echo >&2 "\
  $0 <image_suffix>
  ";exit 1
}

srcroot=$(dirname $0)/ttmp/
status="Checking local irods local source directory"
if [ ! -d $srcroot/irods ] ; then
  status="!! Success !!"
  echo >&2 -n "Trying to unpack irods source locally ... "
  ( cd $srcroot && tar xf irodsSource.tgz 2>/dev/null ) || status="** FAILURE **"
fi
echo >&2 "$status"; [[ $status = *FAIL* ]] && exit 126
#echo >&2 "continuing"; exit 0 # -- dwm

if [ -n "$1" ]; then 
  DOCKVAR="$1"
  echo >&2 BUILDING IMAGE
  docker build --build-arg docker_var=$DOCKVAR -f Dockerfile.dan.$1 -t irods_test_env_$1 .
else
  usage
fi
