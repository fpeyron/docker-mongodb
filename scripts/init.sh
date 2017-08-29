#!/bin/bash

# Start MongoDB service
/usr/bin/mongod --dbpath /data --nojournal &
while ! nc -vz localhost 27017; do sleep 1; done


# Init Data
echo "========================================================================"
for file in /scripts/*.json;
do
    col=$(basename ${file%%.*})
    mongoimport --drop --db ${MONGODB_DBNAME:demo} --collection $col --type json --file $file
done
echo "========================================================================"


# Create User if it defines
if [ ! -z "$MONGODB_USERNAME" ]
then
    USER=${MONGODB_USERNAME:-mongo}
    PASS=${MONGODB_PASSWORD:-$(pwgen -s -1 16)}
    DB=${MONGODB_DBNAME:-admin}

    if [ ! -z "$MONGODB_DBNAME" ]
    then
        ROLE=${MONGODB_ROLE:-dbOwner}
    else
        ROLE=${MONGODB_ROLE:-dbAdminAnyDatabase}
    fi
    echo "Creating user: \"$USER\"..."
    mongo $DB --eval "db.createUser({ user: '$USER', pwd: '$PASS', roles: [ { role: '$ROLE', db: '$DB' } ] });"

    echo "========================================================================"
    echo "MongoDB User: \"$USER\""
    echo "MongoDB Password: \"$PASS\""
    echo "MongoDB Database: \"$DB\""
    echo "MongoDB Role: \"$ROLE\""
    echo "========================================================================"
fi



# Stop MongoDB service
/usr/bin/mongod --dbpath /data --shutdown

