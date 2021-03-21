# Hive Server 2
Dockerfile to build Hive Server 2.

## Build
```
docker build -t hive-server2:3.2.2 .
```

## Config

In addition, to customize Hive deploymnet, environment variables can be used to ingest properties in other configuration files. Environment variables must follow a defined naming pattern in order to be processed: `<PREFIX>_<config_property>=value`. `<Prefix>` encodes the configuration file where the configuration needs to be persisited.

| PREFIX              | File Name          |
|---------------------|--------------------|
| CORE_CONF           | core-site.xml      |
| HDFS_CONF           | hdfs-site.xml      |
| YARN_CONF           | yarn-site.xml      |
| HIVE_SITE_CONF      | hive-site.xml      |
| METASTORE_SITE_CONF | metastore-site.xml |