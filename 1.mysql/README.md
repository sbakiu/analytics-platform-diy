# MySQL Operator
This deployment uses Bitnami helm charts to deploy mysql

Implementation: https://github.com/bitnami/charts

## Requirements

-  Helm 3

## Usage

### Install chart

```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install mysql bitnami/mysql
```

### Create Mysql Secret

```
$(kubectl get secret --namespace default mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode)
```