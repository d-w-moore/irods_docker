#!/bin/bash

suffix=""
preargs=()
while [ $# -ge 1 ]; do
  thing=$1 ; shift
  [ "$thing" = "--" ] && break
  case $thing in
    --s=*) suffix=${thing#*=} ;;
    *)  preargs+=("$thing");;
  esac
done

#========================================================
# make sure we are running the right docker image
#========================================================
echo >&2 "y to proceed , n to cancel, c to change suffix"
echo >&2 "----------------------------------------------"
ans=""
while [ -z "$ans" ]; do
  : "'${suffix:="4_2_s"}'"
  read -p "Action (suffix='$suffix'): " ans
  case $ans in
    [nN]*) break;; [yY]*)  break;; 
    [cC]*) read -p 'Enter new suffix -> ' suffix ; ans='';;
  esac
  ans=''
done

[[ $ans = [nN]* ]] && exit 0 
#exit 123 # -- dwm

#-- verify pre and postargs --
#for x in "${preargs[@]}"; do
# echo pre $((++xx)) $x
#done
#echo "===" $* # remaining = post-args

docker run -it \
  --cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
  --security-opt seccomp=unconfined \
"${preargs[@]}" \
irods_test_env_${suffix}  $*

