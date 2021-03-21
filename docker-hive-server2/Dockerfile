FROM hadoop-base:3.2.2

ARG INITIALIZE
ARG SERVICE
USER root
RUN mkdir -p /var/log/hadoop \
    && chmod -R 777 /var/log

WORKDIR $HIVE_HOME

ADD conf/hive-log4j2.properties $HIVE_HOME/conf
ADD conf/hive-site.xml $HIVE_HOME/conf

RUN chown -R hive:hive $HIVE_HOME
RUN chown -R hive:hive /var/log/hadoop

WORKDIR $HIVE_HOME

# Add Run script
ADD run.sh /run.sh
RUN chown hive:hive /run.sh

USER hive

RUN chmod a+x /run.sh

CMD ["/run.sh"]