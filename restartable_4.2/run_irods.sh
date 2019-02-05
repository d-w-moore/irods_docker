#! /bin/bash

service postgresql start

# - parameters for waiting on DB to start
timeout=30 
tries=0

until pg_isready -q || [ $tries -ge $timeout ]
do
  echo >&2 "Waiting for database ..." $((++tries))
  sleep 1
done

pg_isready -q || { echo >&2 "Quit waiting for ICAT database"; exit 16; }

if ! id -u irods >/dev/null 2>&1
then

  echo >&2 "Installing iRODS ..."
  python /var/lib/irods/scripts/setup_irods.py < /var/lib/irods/packaging/localhost_setup_postgres.input

else

  echo >&2 "Starting up iRODS ..."
  service irods start

fi && echo >&2  $'\n\t --> IRODS Server is running \n'

trap "
    echo >&2 ' ... attempting orderly shutdown of container ... '
    service irods stop && echo >&2 $'\\n\\t <-- IRODS Server is shut down' 
    service postgresql stop
    trap -- '' EXIT ; exit 1
" TERM INT EXIT

#==============

while true
do
  sleep 1
done

