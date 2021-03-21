FROM openjdk:8-jdk-slim

ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=$HADOOP_HOME/bin/:$PATH

ARG HADOOP_VERSION=3.2.2
ARG HADOOP_DOWNLOAD_URL=https://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
ARG HADOOP_DOWNLOAD_DIR=/tmp/hadoop
ARG TIMEZONE=CET

ARG HIVE_VERSION=3.1.2
ARG HIVE_DOWNLOAD_URL=http://apache.lauf-forum.at/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz
ENV HIVE_HOME=/opt/hive
ENV HIVE_CONF_DIR=$HIVE_HOME/conf

RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && \
    echo $TIMEZONE > /etc/timezone

RUN mkdir -p /usr/share/man/man1 \
    && apt-get -q update \
    && apt-get install -q -y --no-install-recommends apt-utils perl curl netcat less procps vim wget telnet \
    && mkdir -p /var/log/hadoop \
    && mkdir -p $HIVE_HOME \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -pv $HADOOP_DOWNLOAD_DIR \
    && curl -fSL "$HADOOP_DOWNLOAD_URL" -o /tmp/hadoop.tar.gz \
    && tar -zxf /tmp/hadoop.tar.gz -C $HADOOP_DOWNLOAD_DIR --strip-components=1 \
    && mv -v $HADOOP_DOWNLOAD_DIR /opt \
    && rm -rfv /tmp/hadoop.tar.gz \
    && rm -rf $HADOOP_HOME/share/doc

# comment out some really gross env variables
# RUN sed -e '/^export HADOOP_DATANODE_OPTS/s/^/#/' -i $HADOOP_CONF_DIR/hadoop-env.sh
# RUN sed -e '/^export HADOOP_NAMENODE_OPTS/s/^/#/' -i $HADOOP_CONF_DIR/hadoop-env.sh
# RUN sed -e '/^export HADOOP_SECONDARYNAMENODE_OPTS/s/^/#/' -i $HADOOP_CONF_DIR/hadoop-env.sh


RUN groupadd --gid 1001 hive
RUN useradd -d /home/hive --uid 1002 -g hive -m hive --shell /bin/bash

# Install hive with aws support
RUN curl -fSL "$HIVE_DOWNLOAD_URL" -o /tmp/hive.tar.gz \
    && tar -zxf /tmp/hive.tar.gz -C $HIVE_HOME --strip-components=1 \
    && rm /tmp/hive.tar.gz \
    && wget -nv https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.375/aws-java-sdk-bundle-1.11.375.jar \
    && wget -nv https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/$HADOOP_VERSION/hadoop-aws-$HADOOP_VERSION.jar \
    && cp hadoop-aws-$HADOOP_VERSION.jar  $HIVE_HOME/lib \
    && cp aws-java-sdk-bundle-1.11.375.jar $HIVE_HOME/lib \
    && rm $HIVE_HOME/lib/guava*.jar \
    && cp $HADOOP_HOME/share/hadoop/common/lib/guava*.jar $HIVE_HOME/lib/

# Custom configuration goes here
ADD conf/httpfs-log4j.properties $HADOOP_CONF_DIR
ADD conf/kms-log4j.properties $HADOOP_CONF_DIR
ADD conf/log4j.properties $HADOOP_CONF_DIR
ADD conf/core-site.xml $HADOOP_CONF_DIR
ADD conf/log4j-timeline.properties $HADOOP_CONF_DIR/timelineserver-config/log4j.properties
ADD conf/log4j-nodemanager.properties $HADOOP_CONF_DIR/nm-config/log4j.properties
ADD conf/log4j-resourcemanager.properties $HADOOP_CONF_DIR/rm-config/log4j.properties
ADD conf/logging.properties $JAVA_HOME/jre/lib
ADD entrypoint.sh /entrypoint.sh

RUN chown -R hive:hive $HADOOP_HOME

RUN chmod a+x /entrypoint.sh
RUN chown -R hive:hive /entrypoint.sh

USER hive
 
ENTRYPOINT ["/entrypoint.sh"]
