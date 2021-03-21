# Hive Metastore
Dockerfile to build Hive Metastore.

## Build
```
docker build -t localhost:5000/hive-metastore:3.2.2 .
```

## Config

In order not to store database password in plain text in `.xml` file, the password is ingested as environmnet variable `$CONNECTION_PASSWORD` and the stored in a file in `run.sh`.

In addition, to customize Hive deploymnet, environment variables can be used to ingest properties in other configuration files. Environment variables must follow a defined naming pattern in order to be processed: `<PREFIX>_<config_property>=value`. `<Prefix>` encodes the configuration file where the configuration needs to be persisited.

| PREFIX              | File Name          |
|---------------------|--------------------|
| CORE_CONF           | core-site.xml      |
| HDFS_CONF           | hdfs-site.xml      |
| YARN_CONF           | yarn-site.xml      |
| HIVE_SITE_CONF      | hive-site.xml      |
| METASTORE_SITE_CONF | metastore-site.xml |