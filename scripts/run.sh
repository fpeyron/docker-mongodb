#!/bin/bash

# Initialize first run
if [[ -e /.firstrun ]]; then
    /scripts/first_run.sh
fi

# Start MongoDB
echo "Starting MongoDB..."
if [ ! -z "$MONGODB_USERNAME" ]
then
    /usr/bin/mongod --dbpath /data --auth $@ --smallfiles
else
    /usr/bin/mongod --dbpath /data --smallfiles
fi
