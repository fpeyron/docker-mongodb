#!/bin/bash

# Start MongoDB service
/usr/bin/mongod --dbpath /data --nojournal &
while ! nc -vz localhost 27017; do sleep 1; done


# Remove existing User
mongo ${MONGODB_DBNAME:demo} --eval "db.dropAllUsers()"

# Initialize Authentification run
if [ ! -z "$MONGODB_USERNAME" ]
then
    USER=${MONGODB_USERNAME:-mongo}
    PASS=${MONGODB_PASSWORD:-$MONGODB_USERNAME}
    DB=${MONGODB_DBNAME:-demo}

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

# Load default datas
if [ ! -e /data/data_loaded ]
then
   echo "Loading collections ..."
   for file in /scripts/*.json;
   do
      col=$(basename ${file%%.*})
      echo "   Collection \"$col\""
      mongoimport --drop --db ${MONGODB_DBNAME:demo} --collection $col --type json --file $file
   done
   touch /data/data_loaded
fi

# Stop MongoDB service
/usr/bin/mongod --dbpath /data --shutdown


# Start MongoDB
echo "Starting MongoDB..."
if [ ! -z "$MONGODB_USERNAME" ]
then
    /usr/bin/mongod --dbpath /data --auth $@
else
    /usr/bin/mongod --dbpath /data $@ 
fi
