#!/bin/bash

set -e

echo "🚀 Starting Minikube..."
minikube start --driver=docker

echo "📊 Enabling metrics-server..."
minikube addons enable metrics-server

echo "📁 Applying Kubernetes manifests..."
kubectl apply -f Redis-master.yml
kubectl rollout status deployment/redis-master

kubectl apply -f Redis-replicas.yml
kubectl rollout status deployment/redis-replica

kubectl apply -f BackendDep.yml
kubectl rollout status deployment/mynodeapp

kubectl apply -f ReactDep.yml
kubectl rollout status deployment/react-app

echo "⚖️ Setting up autoscaling..."
kubectl autoscale deployment redis-replica --cpu-percent=25 --min=2 --max=5
kubectl autoscale deployment mynodeapp --cpu-percent=30 --min=2 --max=5

echo "Downloading helm..."

sudo curl -fsSL https://get.helm.sh/helm-v3.9.4-linux-amd64.tar.gz -o helm-v3.9.4-linux-amd64.tar.gz
sudo tar -zxvf helm-v3.9.4-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
sudo rm helm-v3.9.4-linux-amd64.tar.gz

echo "📦 Adding Prometheus Helm repo..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts || true
helm repo update

echo "🔍 Creating monitoring namespace..."
kubectl create namespace monitoring || echo "Namespace already exists"

echo "📈 Installing kube-prometheus-stack..."
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring

echo "🛠️ Waiting for Prometheus and Grafana pods to be ready..."
kubectl rollout status deployment/prometheus-grafana -n monitoring
kubectl rollout status deployment/prometheus-kube-prometheus-operator -n monitoring

echo "🧩 Deploying ServiceMonitor for backend..."
kubectl apply -f Service-monitoring.yml


echo "🌐 Exposing Grafana on NodePort (30000)..."
kubectl patch svc prometheus-grafana -n monitoring --type='merge' -p '{
  "spec": {
    "type": "NodePort",
    "ports": [{
      "port": 80,
      "targetPort": 3000,
      "protocol": "TCP",
      "nodePort": 30000
    }]
  }
}'

echo "🔑 The react app is accessibler through the address : "
minikube service react-app-service --url
echo " "
echo "🔑 grafana is accessible through the address : "
minikube service prometheus-grafana -n monitoring --url
echo " "
echo " Importing Grafana dashboard..."

curl -X POST -H "Content-Type: application/json" -H "Accept: application/json" \
-d @projet-grafana-dashboard.json \
'http://admin:prom-operator@192.168.49.2:30000/api/dashboards/import'
echo " "
echo "📊 Dashboard accesible at http://192.168.49.2:30000/d/aei3q9u5adj40a"
echo " "
echo "Prometheus UI accessible at http://localhost:9090"
echo " "
kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090

echo "🚀 Minikube setup complete!"

