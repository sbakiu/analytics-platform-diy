# Generate Hive credentials file
hadoop credential create javax.jdo.option.ConnectionPassword -provider jceks://file/$HIVE_HOME/conf/hive.jceks -value $CONNECTION_PASSWORD

echo "=========================================="
echo "Starting Hive Metastore."
echo "=========================================="
$HIVE_HOME/bin/hive --service $SERVICE --hiveconf hive.log.dir=/var/log/$SERVICE/
