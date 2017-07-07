#!/bin/bash
function extract_env {
    docker run --rm $TAG sh -c 'echo $'${1}
}
TAG=local/hadoop-2
docker build -t $TAG --rm=true .
bash ./clean_up_images.sh
export HDFS_VOL1=`extract_env HDFS_VOL1`
export HDFS_VOL2=`extract_env HDFS_VOL2`
