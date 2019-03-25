#!/bin/sh
docker-compose stop baijiacloud
docker rm baijiacloud

images=`docker images | awk '{print $2" "$3}'| grep "<none>"| awk '{print $2}'`
if [ "$images" != "" ]; then
    for i in $images
    do
        docker rmi "$i"
    done
fi
