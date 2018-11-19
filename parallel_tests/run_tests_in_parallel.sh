#! /bin/bash

test_logs_home=$HOME/irods_test_env
test_name_prefix=
test_hooks_volume_mount=

while [ "$1" != "" ]; do
    case $1 in
        --logs-home)    shift; test_logs_home=$1;;
        --prefix)       shift; test_name_prefix=${1}_;;
        --hooks)        shift; test_hooks_volume_mount="-v $1:/test_hooks";;

        --logs-home=*)  test_logs_home="${1#*=}";;
        --prefix=*)     test_name_prefix="${1#*=}_";;
        --hooks=*)      test_hooks_volume_mount="-v ${1#*=}:/test_hooks";;
    esac
    shift
done

# Setup where test logs/output should be stored.
[ ! -d $test_logs_home ] && mkdir $test_logs_home

for name in test_iput_options 
#           test_all_rules \
#           test_catalog \
#           test_control_plane \
#           test_iadmin \
#           test_ichksum \
#           test_ichmod \
#           test_icommands_file_operations \
#           test_ils \
#           test_imeta_help \
#           test_imeta_set \
#           test_ipasswd \
#           test_iput_options \
#           test_iquest \
#           test_ireg \
#           test_irepl \
#           test_irm \
#           test_irmdir \
#           test_irodsctl \
#           test_irsync \
#           test_iscan \
#           test_iticket \
#           test_itrim \
#           test_load_balanced_suite \
#           test_native_rule_engine_plugin \
#           test_quotas \
#           test_resource_configuration \
#           test_resource_tree \
#           test_resource_types \
#           test_rulebase \
#           test_ssl \
#           test_symlink_operations
do
    docker run -d --rm --name ${test_name_prefix}${name} $test_hooks_volume_mount -v $test_logs_home:/irods_test_env irods_test_env $name
done

