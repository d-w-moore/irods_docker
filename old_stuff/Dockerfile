FROM ubuntu:16.04

# Set the default shell for executing commands.
SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install -y apt-transport-https vim git postgresql wget

# Setup ICAT database.
ADD db_commands.txt /db_commands.txt
RUN service postgresql start && su - postgres -c "psql -f /db_commands.txt"

# Setup iRODS.
RUN service postgresql start && \
    wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add -; \
    echo "deb [arch=amd64] https://packages.irods.org/apt/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/renci-irods.list; \
    apt-get update && \
    apt-get install -y irods-server irods-auth-plugin-krb irods-database-plugin-postgres ; \
    service postgresql stop
    #python /var/lib/irods/scripts/setup_irods.py < /var/lib/irods/packaging/localhost_setup_postgres.input

CMD ["/bin/bash"]
# docker build -t irods_pkg .
# docker build -t irods_pkg_run -f Dockerfile.runirods .
