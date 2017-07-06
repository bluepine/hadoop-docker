FROM bluepine/bigdata-alpine-base

MAINTAINER "Song Wei"

### Env
ENV HADOOP_VERSION=2.8.0
ENV HDFS_USER=hdfsuser
ENV HDFS_USER_CODE_DIR=/home/$HDFS_USER/.usr
ENV HDFS_USER_DATA_DIR=/home/$HDFS_USER/.data
ENV HDFS_VOL1=$HDFS_USER_DATA_DIR/hdfs1 HDFS_VOL2=$HDFS_USER_DATA_DIR/hdfs2
ENV HADOOP_HOME=$HDFS_USER_CODE_DIR/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop \
  HADOOP_LIBEXEC_DIR=$HADOOP_HOME/libexec \
  PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:/opt/util/bin

### Run
RUN adduser -S -D -g "" $HDFS_USER \
    && addgroup $HDFS_USER \
    && sync \
    && mkdir -p "${HADOOP_HOME}" \
    && export ARCHIVE=hadoop-$HADOOP_VERSION.tar.gz \
    && export DOWNLOAD_PATH=apache/hadoop/common/hadoop-$HADOOP_VERSION/$ARCHIVE \
    && curl -sSL https://mirrors.ocf.berkeley.edu/$DOWNLOAD_PATH | \
       tar -xz -C $HADOOP_HOME --strip-components 1 \
    && rm -rf $ARCHIVE \
    && rm -rf $HADOOP_HOME/share/doc \
    && apk update && apk add procps && rm -rf /var/cache/apk/* \
    && mkdir -p $HDFS_VOL1 \
    && mkdir -p $HDFS_VOL2 \
    && chown -R $HDFS_USER:$HDFS_USER $HDFS_VOL1 $HDFS_VOL2 \
    && chown -R $HDFS_USER:$HDFS_USER $HADOOP_HOME \
    && sync

### User
USER $HDFS_USER

### Volume: using unamed volumes since replica services do not work with named volumes without plugins.
VOLUME $HDFS_VOL1
VOLUME $HDFS_VOL2

### Copy
COPY ./conf/*.xml $HADOOP_CONF_DIR/
COPY start-hadoop-namenode /opt/util/bin/start-hadoop-namenode
COPY start-hadoop-datanode /opt/util/bin/start-hadoop-datanode
COPY start-hadoop-secondarynamenode /opt/util/bin/start-hadoop-secondarynamenode

