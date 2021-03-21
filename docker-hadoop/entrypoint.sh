#!/bin/bash

function addProperty() {
    local path=$1
    local name=$2
    local value=$3

    if [[ -f ${path} ]]; then
        local entry="<property><name>$name</name><value>${value}</value></property>"
        local escapedEntry=$(echo ${entry} | sed 's/[^a-zA-Z0-9,._+@%/-]/\\&/g; 1{$s/^$/""/}; 1!s/^/"/; $!s/$/"/')
        echo "escaped entry ${escapedEntry}"
        sed -i "/<\/configuration>/i ${escapedEntry}\n" ${path}
        echo "Added property ${name}=${value} to the file '${path}'."
    else
        echo "Unable to add property ${name}=${value}. The file '${path}' in not found."
    fi
}

function configure() {
    local path=$1
    local module=$2
    local envPrefix=$3

    if [[ -f ${path} ]]; then

        echo "Configuring $module"

        for c in `printenv | perl -sne 'print "$1 " if m/^${envPrefix}_(.+?)=.*/' -- -envPrefix=${envPrefix}`; do
            local name=`echo ${c} | perl -pe 's/___/-/g; s/__/_/g; s/_/./g'`
            local var="${envPrefix}_${c}"
            local value=${!var}

            echo " - Setting $name=$value"
            addProperty ${path} ${name} "$value"

            echo " - Un-setting ${var}"
            unset ${var}
        done

    else
        echo "Unable to configure module ${module}. The file '${path}' in not found."
    fi
}

configure ${HADOOP_CONF_DIR}/core-site.xml core CORE_CONF
configure ${HADOOP_CONF_DIR}/hdfs-site.xml hdfs HDFS_CONF
configure ${HADOOP_CONF_DIR}/yarn-site.xml yarn YARN_CONF
configure ${HADOOP_CONF_DIR}/httpfs-site.xml httpfs HTTPFS_CONF
configure ${HADOOP_CONF_DIR}/kms-site.xml kms KMS_CONF
configure ${HADOOP_CONF_DIR}/mapred-site.xml mapred MAPRED_CONF
configure ${HIVE_CONF_DIR}/hive-site.xml hive HIVE_SITE_CONF
configure ${HIVE_CONF_DIR}/metastore-site.xml metastore METASTORE_SITE_CONF
configure ${METASTORE_HOME}/conf/metastore-site.xml metastore METASTORE_STANDALONE_CONF

#addProperty ${HADOOP_CONF_DIR}/hdfs-site.xml dfs.namenode.rpc-bind-host 0.0.0.0
#addProperty ${HADOOP_CONF_DIR}/hdfs-site.xml dfs.namenode.servicerpc-bind-host 0.0.0.0
#addProperty ${HADOOP_CONF_DIR}/hdfs-site.xml dfs.namenode.http-bind-host 0.0.0.0
#addProperty ${HADOOP_CONF_DIR}/hdfs-site.xml dfs.namenode.https-bind-host 0.0.0.0
#addProperty ${HADOOP_CONF_DIR}/hdfs-site.xml dfs.client.use.datanode.hostname true
#addProperty ${HADOOP_CONF_DIR}/hdfs-site.xml dfs.datanode.use.datanode.hostname true
#addProperty ${HADOOP_CONF_DIR}/yarn-site.xml yarn.resourcemanager.bind-host 0.0.0.0
#addProperty ${HADOOP_CONF_DIR}/yarn-site.xml yarn.nodemanager.bind-host 0.0.0.0
#addProperty ${HADOOP_CONF_DIR}/yarn-site.xml yarn.timeline-service.bind-host 0.0.0.0
#addProperty ${HADOOP_CONF_DIR}/mapred-site.xml yarn.nodemanager.bind-host 0.0.0.0


function waitForService() {

    local servicePort=$1
    local service=${servicePort%%:*}
    local port=${servicePort#*:}
    local retrySeconds=5
    local max_try=100
    let i=1

    nc -z ${service} ${port}
    result=$?

    until [[ ${result} -eq 0 ]]; do

        echo "[$i/$max_try] ${service}:${port} is not available yet"

        if (( $i == $max_try )); then
            echo "[$i/$max_try] ${service}:${port} is still not available; giving up after ${max_try} tries. :/"
            exit 1
        fi

        let "i++"
        sleep ${retrySeconds}

        nc -z ${service} ${port}
        result=$?
    done

    echo "[$i/$max_try] $service:${port} is available."
}

for i in ${SERVICE_PRECONDITION[@]}
do
    waitForService ${i}
done

exec $@
