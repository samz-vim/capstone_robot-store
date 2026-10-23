#!/usr/bin/env bash
set -euo pipefail
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts || true
helm repo add grafana https://grafana.github.io/helm-charts || true
helm repo update
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -
helm upgrade --install monitoring prometheus-community/kube-prometheus-stack -n monitoring -f monitoring/kube-prometheus-stack-values.yaml
helm upgrade --install loki grafana/loki -n monitoring -f monitoring/loki-values.yaml
helm upgrade --install fluent-bit grafana/fluent-bit -n monitoring -f monitoring/fluent-bit-values.yaml
kubectl create namespace tracing --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f tracing/jaeger-all-in-one.yaml
kubectl apply -f monitoring/robot-shop-alerts.yaml
echo 'Observability resources submitted. Check with: kubectl get pods -n monitoring; kubectl get pods -n tracing'
