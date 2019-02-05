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

fi && echo >&2  $'\n --> IRODS Server is running \n'

cleanup() 
{
    echo >&2 " ... attempting shutdown of irods and ICAT "
    service irods stop && echo >&2 $'\n <-- IRODS Server is shut down' 
    service postgresql stop
}
f() { trap -- EXIT; trap -- INT; trap -- TERM; cleanup; }

trap 'f' TERM INT EXIT

sleep $(( (1 << 31) - 1 ))'d' # a very long wait

