FROM hadoop-base:3.2.2

ARG SERVICE

USER root
RUN mkdir -p /user/hive/warehouse \
    && chmod -R 777 /var/log

ARG MYSQL_CONNECTOR_VERSION=5.1.47
ARG MYSQL_CONNECTOR_DOWNLOAD_URL=https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-$MYSQL_CONNECTOR_VERSION.tar.gz

# Download and install the mysql connector.
RUN curl -fSL "$MYSQL_CONNECTOR_DOWNLOAD_URL" -o /tmp/mysql_connector.tar.gz \
	&& tar -zxf /tmp/mysql_connector.tar.gz -C /opt/ \
	&& rm /tmp/mysql_connector.tar.gz \
	&& ln -s /opt/mysql-connector-java-$MYSQL_CONNECTOR_VERSION/mysql-connector-java-$MYSQL_CONNECTOR_VERSION.jar /opt/hadoop/share/hadoop/common/lib/ \
	&& ln -s /opt/mysql-connector-java-$MYSQL_CONNECTOR_VERSION/mysql-connector-java-$MYSQL_CONNECTOR_VERSION.jar $HIVE_HOME/lib/ 

RUN hdfs dfs -chown -R hive:hive /user/hive

WORKDIR $HIVE_HOME

ADD conf/metastore-log4j2.properties $HIVE_HOME/conf
ADD conf/hive-site.xml $HIVE_HOME/conf
ADD conf/metastore-site.xml $HIVE_HOME/conf

RUN chown -R hive:hive $HIVE_HOME
RUN chown -R hive:hive /var/log/hadoop

WORKDIR $HIVE_HOME

# Add Run script
ADD run.sh /run.sh
RUN chown hive:hive /run.sh

USER hive

RUN chmod a+x /run.sh

CMD ["/run.sh"]
