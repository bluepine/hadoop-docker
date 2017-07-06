FROM bluepine/bigdata-alpine-base

MAINTAINER "Song Wei"

### Env
ENV HADOOP_VERSION=2.8.0
ENV HADOOP_HOME=/usr/local/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop \
  HADOOP_LIBEXEC_DIR=$HADOOP_HOME/libexec \
  PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:/opt/util/bin \
  HDFS_USER=hdfsuser

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
    && apk update && apk add procps && rm -rf /var/cache/apk/* \
    && mkdir /opt/hdfs \
    && mkdir /opt/hdfs2 \
    && chown -R $HDFS_USER:$HDFS_USER /opt/hdfs /opt/hdfs2 \
    && chown -R $HDFS_USER:$HDFS_USER $HADOOP_HOME \
    && sync

### User
USER $HDFS_USER

### Volume: using unamed volumes since replica services do not work with named volumes without plugins.
VOLUME /opt/hdfs
VOLUME /opt/hdfs2

### Copy
COPY ./conf/*.xml $HADOOP_CONF_DIR/
COPY start-hadoop-namenode /opt/util/bin/start-hadoop-namenode
COPY start-hadoop-datanode /opt/util/bin/start-hadoop-datanode
COPY start-hadoop-secondarynamenode /opt/util/bin/start-hadoop-secondarynamenode

