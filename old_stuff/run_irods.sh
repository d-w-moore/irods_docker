#! /bin/sh

service postgresql start

if ! id -u irods >/dev/null 2>&1
then
  echo >&2 "Installing iRODS ..."
  python /var/lib/irods/scripts/setup_irods.py < /var/lib/irods/packaging/localhost_setup_postgres.input
else
  echo >&2 "Starting up iRODS ..."
  service irods start
fi && {
          echo >&2  $'\n\n --> RUNNING IRODS \n'
      }

trap " service irods stop && echo >&2 $'\\n\\n <-- SHUT DOWN IRODS' ; \
       service postgresql stop ; date +%s >>/tmp/shutdown.log" TERM EXIT

sleep $(( (1 << 31) - 1 )) # seconds to heat death in a 32-bit universe
