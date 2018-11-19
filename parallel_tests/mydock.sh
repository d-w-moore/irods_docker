#!/bin/bash

preargs=()
while [ $# -ge 1 ]; do
  thing=$1 ; shift
  [ "$thing" = "--" ] && break
  preargs+=("$thing")
done

#-- verify pre and postargs --
#for x in "${preargs[@]}"; do
# echo pre $((++xx)) $x
#done
#echo "===" $* # remaining = post-args

docker run -it \
  --cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
  --security-opt seccomp=unconfined \
"${preargs[@]}" \
irods_test_env_4_2_s  $*

