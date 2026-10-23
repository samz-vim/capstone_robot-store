#!/usr/bin/env bash
set -euo pipefail
helm repo add robot-shop https://raw.githubusercontent.com/instana/robot-shop/master/K8s/helm || true
helm repo update
kubectl create namespace robot-shop --dry-run=client -o yaml | kubectl apply -f -
helm upgrade --install robot-shop robot-shop/robot-shop -n robot-shop
echo 'Robot Shop deployment submitted. Check with: kubectl get pods,svc -n robot-shop'
