#!/bin/bash
#This is needed to allow docker to push images to minikube's registry: https://minikube.sigs.k8s.io/docs/handbook/registry/#docker-on-macos
minikube addons enable registry
minikube addons enable ingress
docker run --rm -it --network=host alpine ash -c "apk add socat && socat TCP-LISTEN:5000,reuseaddr,fork TCP:$(minikube ip):5000"