#!/bin/bash

echo "Deleting Kubernetes resources..."
./delete.sh

echo "Stopping Minikube cluster..."
minikube stop
