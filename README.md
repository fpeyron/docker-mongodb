# MongoDB Dockerfile

Docker Image for [MongoDB](http://www.mongodb.org/) built with official Community sources

## MongoDB version

The `master` branch currently hosts MongoDB 2.6.

Different versions of MongoDB are located at the github repo [branches](https://github.com/fpeyron/docker-mongodb/branches).

## Usage

### Build image

To create locally the image `florentpeyron/mongodb`:

```
$ docker build -t \
	florentpeyron/mongodb .
```

### Run the image (default)

To run image and bind to host MongoDB port (27017) and Http interface :

```
$ docker run -d \
	--name mongodb \
	-p 27017:27017 \
	-p 28017:28017 \
	florentpeyron/mongodb 
```

### Run the image with credential

You have to fill environment variable :
* `MONGODB_USERNAME` to set username

And you can fill this environment variable :
* `MONGODB_PASSWORD` to specify password (by default is username)
* `MONGODB_DBNAME` to specify dbname (by default `admin`)
* `MONGODB_ROLE` to specify login's role (by default `dbAdminAnyDatabase` if `MONGODB_DBNAME` is empty else `dbOwner` )

To run image with credential :

```
$ docker run -d \
    --name mongodb \
    -p 27017:27017 \
    -e MONGODB_USERNAME=myLogin \
    -e MONGODB_PASSWORD=myPassword \
    -e MONGODB_DBNAME=sample \
    florentpeyron/mongodb
```


The first time you run your container,  a new user `mongo` with all privileges will be created with a random password.
To get the password, check the logs of the container by running:


```

#### Credentials

If you want to preset credentials instead of a random generated ones, you can set the following environment variables:

* `MONGODB_USERNAME` to set a specific username
* `MONGODB_PASSWORD` to set a specific password

On this example we will preset our custom username and password:

```
$ docker run -d \
    --name mongodb \
    -p 27017:27017 \
    -e MONGODB_USERNAME=myusername \
    -e MONGODB_PASSWORD=mypassword \
    florentpeyron/mongodb
```

#### Databases

If you want to create a database at container's boot time, you can set the following environment variables:

* `MONGODB_DBNAME` to create a database
* `MONGODB_ROLE` to grant the user a role to the database (by default `dbOwner`)

On this example we will preset our custom username and password and we will create a database with the default role:

```
$ docker run -d \
    --name template-mongodb \
    -p 27017:27017 \
    -e MONGODB_USERNAME=myusername \
    -e MONGODB_PASSWORD=mypassword \
    -e MONGODB_DBNAME=mydb \
    template-mongodb
```


#### Persistent data

The store data is `/data`. It possible to map this volume with the host and persistent updating after restarts :
```
$ mkdir -p /tmp/mongodb
$ docker run \
    --name template-mongodb \
    -p 27017:27017 \
    -v /tmp/mongodb:/data \
    template-mongodb:latest
```

## 
```
docker build -t newsbridge/template-mongodb:latest -t 677537359471.dkr.ecr.eu-west-1.amazonaws.com/template-mongodb:latest .
docker tag newsbridge/template-mongodb:latest newsbridge/template-mongodb:3.4
$(aws ecr get-login --no-include-email)
docker push 677537359471.dkr.ecr.eu-west-1.amazonaws.com/template-mongodb:latest
docker push 677537359471.dkr.ecr.eu-west-1.amazonaws.com/template-mongodb:3.4
``` 

## Copyright

Copyright (c) 2014 Ferran Rodenas. 
Copyright (c) 2017 Florent Peyron