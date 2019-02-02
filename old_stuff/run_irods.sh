#! /bin/sh

service postgresql start

until pg_isready -q 
do
  echo >&2 "Waiting for database ..."
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

trap " service irods stop && echo >&2 $'\\n <-- IRODS Server is shut down' ; \
       service postgresql stop ; date >>/tmp/shutdown.log" TERM INT

sleep $(( (1 << 31) - 1 )) # seconds to heat death in a 32-bit universe
