#!/bin/bash

kubectl delete -f Redis-master.yml
kubectl delete -f Redis-replicas.yml
kubectl delete -f BackendDep.yml
kubectl delete -f ReactDep.yml
kubectl delete -f Service-monitoring.yml
helm uninstall prometheus -n monitoring
kubectl delete hpa mynodeapp
kubectl delete hpa redis-replica

kubectl get pods -n monitoring && kubectl get pods -n default
kubectl get svc -n monitoring && kubectl get svc -n default

minikube stop
echo "Deleted all resources and stopped minikube."