#!/bin/bash
TAG=local/hadoop-2
bash ./stop.sh
docker build -t $TAG --rm=true .
bash ./clean_up_images.sh
function extract_env {
    docker run --rm $TAG sh -c 'echo $'${1}
}
#docker-compose up
export HDFS_VOL1=`extract_env HDFS_VOL1`
export HDFS_VOL2=`extract_env HDFS_VOL2`
docker stack deploy --compose-file=docker-compose.yml hadoop

