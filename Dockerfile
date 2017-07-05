FROM bluepine/bigdata-alpine-base

MAINTAINER "Song Wei"

# Version
ENV HADOOP_VERSION=2.8.0

# Set paths
# Set home
ENV HADOOP_HOME=/usr/local/hadoop-$HADOOP_VERSION

ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop \
  HADOOP_LIBEXEC_DIR=$HADOOP_HOME/libexec \
  PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:/opt/util/bin \
  HDFS_USER=hdfsuser


# Install Hadoop
RUN adduser -S -D -H -g "" $HDFS_USER \
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


USER $HDFS_USER

# HDFS volume
VOLUME /opt/hdfs
VOLUME /opt/hdfs2

# Copy and fix configuration files
COPY ./conf/*.xml $HADOOP_CONF_DIR/
# Copy start scripts
COPY start-hadoop-namenode /opt/util/bin/start-hadoop-namenode
COPY start-hadoop-datanode /opt/util/bin/start-hadoop-datanode
COPY start-hadoop-secondarynamenode /opt/util/bin/start-hadoop-secondarynamenode


# RUN sed -i.bak "s/hadoop-daemons.sh/hadoop-daemon.sh/g" \
#     $HADOOP_HOME/sbin/start-dfs.sh \
#   && rm -f $HADOOP_HOME/sbin/start-dfs.sh.bak \
#   && sed -i.bak "s/hadoop-daemons.sh/hadoop-daemon.sh/g" \
#     $HADOOP_HOME/sbin/stop-dfs.sh \
#   && rm -f $HADOOP_HOME/sbin/stop-dfs.sh.bak && sync

# # Install dependencies
# RUN apt-get update \
#   && DEBIAN_FRONTEND=noninteractive apt-get install \
#     -yq --no-install-recommends netcat \
#   && apt-get clean \
# 	&& rm -rf /var/lib/apt/lists/*



# # HDFS
# EXPOSE 8020 14000 50070 50470

# # MapReduce
# EXPOSE 10020 13562	19888


# # Fix environment for other users
# RUN echo "export HADOOP_HOME=$HADOOP_HOME" > /etc/bash.bashrc.tmp \
#   && echo 'export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:/opt/util/bin'>> /etc/bash.bashrc.tmp \
#   && cat /etc/bash.bashrc >> /etc/bash.bashrc.tmp \
#   && mv -f /etc/bash.bashrc.tmp /etc/bash.bashrc
