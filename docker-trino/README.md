# trino
Dockerfile to create Trino image.

## Build
```
docker build -t localhost:5000/trino:354 .
```

## Configuration

Trino configuration is provided in `/etc`. Configuration files are:
* `node.properties` environmental configuration specific to each node
* `log.properties` allows setting the minimum log level
* `jvm.config` command line options for the Java Virtual Machine
* `config.properties` configuration for the trino server
* `./catalog` configurations for the connectors(data sources)

Detailed information [here](https://trino.io/docs/current/installation/deployment.html)