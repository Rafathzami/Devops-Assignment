#!/bin/bash

set -e  

echo "Starting Minikube..."
minikube start --driver=docker --memory=4g --cpus=2

echo "Creating required namespaces..."
kubectl create namespace argocd || echo "Namespace already exists"
kubectl create namespace monitoring || echo "Namespace already exists"

echo "Adding Helm repositories..."
helm repo add argo https://argoproj.github.io/argo-helm
helm repo add prometheus https://prometheus-community.github.io/helm-charts
helm repo update

echo "Installing ArgoCD..."
helm install argocd argo/argo-cd -n argocd --set server.service.type=NodePort

echo "Installing Prometheus..."
helm install prometheus prometheus/prometheus -n monitoring --set server.service.type=NodePort

echo "Installing Grafana..."
helm install grafana prometheus/grafana -n monitoring --set service.type=NodePort

echo "Waiting for deployments to stabilize..."
kubectl rollout status deployment/argocd-server -n argocd
kubectl rollout status deployment/prometheus-server -n monitoring
kubectl rollout status deployment/grafana -n monitoring

echo "Fetching service URLs..."
ARGOCD_URL=$(minikube service argocd-server -n argocd --url)
PROMETHEUS_URL=$(minikube service prometheus-server -n monitoring --url)
GRAFANA_URL=$(minikube service grafana -n monitoring --url)

echo "Access ArgoCD: $ARGOCD_URL"
echo "Access Prometheus: $PROMETHEUS_URL"
echo "Access Grafana: $GRAFANA_URL"

echo "Infrastructure setup completed successfully!"
