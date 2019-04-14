#!/bin/bash

BASEDIR=~/Applications/unifi-video
IP=0.0.0.0

NAME=unifi-video
VERSION=v3.10.2

# Run docker once to create a container and return the ID
# For following startups, use 'docker start <containerID>'

CONTAINER=`docker ps -a --filter ancestor=exsilium/unifi-video:$VERSION --format "{{.ID}}"`

if [ ! -z $CONTAINER ]
then
  echo "There seems to be an existing container with the ancestor image. Please use 'docker start <containerID> to start it."
  docker ps -a --filter ancestor=exsilium/unifi-video:$VERSION --format "table {{.ID}}\t{{.Names}}\t{{.CreatedAt}}\t{{.Status}}"
  echo "==> Exiting without doing anything!"
else
  printf "Checking for Host data volumes and directories: MongoDB-"
  if [ -d $BASEDIR/mongodb ]
  then
    printf "OK"
  else
    printf "NOK\n"
    echo "Please make sure you have created the following directory: $BASEDIR/mongodb"
    exit 1;
  fi
  printf " | Unifi-Video-"
  if [ -d $BASEDIR/unifi-video ]
  then
    printf "OK"
  else
    printf "NOK\n"
    echo "Please make sure you have created the following directory: $BASEDIR/unifi-video"
    exit 1;
  fi
  printf " | Log-"
  if [ -d $BASEDIR/unifi-video/logs ]
  then
    printf "OK"
  else
    printf "NOK\n"
    echo "Please make sure you have created the following directory: $BASEDIR/unifi-video/logs"
    exit 1;
  fi
  printf "\n"
  docker run -d --privileged \
  -v $BASEDIR/mongodb:/var/lib/mongodb \
  -v $BASEDIR/unifi-video:/var/lib/unifi-video \
  -p $IP:6666:6666 \
  -p $IP:7080:7080 \
  -p $IP:7442:7442 \
  -p $IP:7443:7443 \
  -p $IP:7445:7445 \
  -p $IP:7446:7446 \
  -p $IP:7447:7447 \
  --name $NAME \
  --restart=unless-stopped \
  exsilium/unifi-video:$VERSION
fi
