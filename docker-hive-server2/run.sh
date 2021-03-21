#!/bin/bash

hdfs dfs -mkdir -p /tmp/hive
hdfs dfs -chmod 777 /tmp/hive
echo "=========================================="
echo "Starting Hive $SERVICE"
echo "=========================================="
$HIVE_HOME/bin/hive --service $SERVICE