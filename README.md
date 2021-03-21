# analytics-platform-diy


## Installation

### Build and push Docker images
```
cd docker-hadoop
docker build -t hadoop-base:3.2.2 -f  .
cd ../docker-hive-metastore
docker build -t localhost:5000/hive-metastore:3.2.2 .
cd ../docker-hive-server2
docker build -t localhost:5000/hive-server2:3.2.2 .
cd ../docker-trino
docker build -t localhost:5000/trino:354 .
cd ..

docker push localhost:5000/hive-metastore:3.2.2
docker push localhost:5000/hive-server2:3.2.2
docker push localhost:5000/trino:354
```

### Install MySQL
```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install mysql bitnami/mysql
```
Export Secret
```
kubectl create secret generic mysql-secret --from-literal=ROOT_PASSWORD=$(kubectl get secret --namespace default mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode)
```

### Install Hive Metastore
```
helm install hive-metastore ./2.hive-metastore 
```

### Install Hive Server2
```
helm install hive-server2 ./3.hive-server2 
```

### Install Trino
```
helm install trino ./5.trino
```