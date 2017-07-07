FROM frolvlad/alpine-oraclejdk8:slim

MAINTAINER "Song Wei"

### Env
ENV HADOOP_VERSION=2.8.0
ENV USER=hdfsuser
ENV USER_HOME=/home/$USER \
    HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
ENV USER_CODE=/opt/usr \
    USER_DATA=$USER_HOME/.data \
    USER_CONF=$USER_HOME/.etc
ENV HDFS_VOL1=$USER_DATA/hdfs1 \
    HDFS_VOL2=$USER_DATA/hdfs2 \
    HADOOP_CONF_DIR=$USER_CONF/hadoop \
    HADOOP_LIBEXEC_DIR=$HADOOP_HOME/libexec \
    PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$USER_CODE/util/bin


### Copy
COPY copy/conf/*.xml $HADOOP_CONF_DIR/
COPY copy/bin/* $USER_CODE/util/bin/
COPY copy/root/* /root

RUN sh /root/install.sh

### User
USER $USER
