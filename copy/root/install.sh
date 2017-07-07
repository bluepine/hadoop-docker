#!/bin/sh
#installation script used when building docker image. use at most one.
set -x
mkdir -p /opt
apk add --no-cache curl netcat-openbsd
adduser -S -D -g "" $USER;
addgroup $USER;
mkdir -p "${HADOOP_HOME}";
export ARCHIVE=hadoop-$HADOOP_VERSION.tar.gz;
export DOWNLOAD_PATH=apache/hadoop/common/hadoop-$HADOOP_VERSION/$ARCHIVE;
curl -sSL https://mirrors.ocf.berkeley.edu/$DOWNLOAD_PATH | tar -xz -C $HADOOP_HOME --strip-components 1;
rm -rf $ARCHIVE;
rm -rf $HADOOP_HOME/share/doc;
cp -r  $HADOOP_CONF_DIR/* $HADOOP_HOME/etc/hadoop
cp -r  $HADOOP_HOME/etc/hadoop/* $HADOOP_CONF_DIR
mkdir -p $HDFS_VOL1;
mkdir -p $HDFS_VOL2;
#assume all directories owned by $USER are inside $USER_HOME
chown -R $USER:$USER $USER_HOME;
sync
