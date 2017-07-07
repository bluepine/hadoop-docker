FROM bluepine/bigdata-alpine-base

MAINTAINER "Song Wei"

### Env
ENV HADOOP_VERSION=2.8.0

ENV USER=hdfsuser
ENV USER_HOME=/home/$USER
ENV USER_CODE=$USER_HOME/.usr
ENV USER_DATA=$USER_HOME/.data


ENV HDFS_VOL1=$USER_DATA/hdfs1 HDFS_VOL2=$USER_DATA/hdfs2
ENV HADOOP_HOME=$USER_CODE/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop \
  HADOOP_LIBEXEC_DIR=$HADOOP_HOME/libexec \
  PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$USER_CODE/util/bin

### Run
RUN adduser -S -D -g "" $USER \
    && addgroup $USER \
    && sync \
    && mkdir -p "${HADOOP_HOME}" \
    && export ARCHIVE=hadoop-$HADOOP_VERSION.tar.gz \
    && export DOWNLOAD_PATH=apache/hadoop/common/hadoop-$HADOOP_VERSION/$ARCHIVE \
    && curl -sSL https://mirrors.ocf.berkeley.edu/$DOWNLOAD_PATH | \
       tar -xz -C $HADOOP_HOME --strip-components 1 \
    && rm -rf $ARCHIVE \
    && rm -rf $HADOOP_HOME/share/doc \
    && apk update && apk add procps supervisor && rm -rf /var/cache/apk/* \
    && mkdir -p $HDFS_VOL1 \
    && mkdir -p $HDFS_VOL2 \
    && chown -R $USER:$USER $USER_HOME \
    && sync

### User
USER $USER

### Volume: using unamed volumes since replica services do not work with named volumes without plugins.
VOLUME $HDFS_VOL1
VOLUME $HDFS_VOL2

### Copy
COPY ./conf/*.xml $HADOOP_CONF_DIR/
COPY start-hadoop-namenode $USER_CODE/util/bin/start-hadoop-namenode
COPY start-hadoop-datanode $USER_CODE/util/bin/start-hadoop-datanode
COPY start-hadoop-secondarynamenode $USER_CODE/util/bin/start-hadoop-secondarynamenode

