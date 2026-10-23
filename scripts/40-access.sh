#!/usr/bin/env bash
set -euo pipefail
cat <<'EOF'
Start each desired port-forward in a separate terminal. Confirm service names/ports first with:
  kubectl get svc -n robot-shop
  kubectl get svc -n monitoring
  kubectl get svc -n tracing

Common commands (Robot Shop service/port may differ by chart version):
  kubectl port-forward -n robot-shop svc/robot-shop 8080:8080
  kubectl port-forward -n monitoring svc/monitoring-grafana 3000:80
  kubectl port-forward -n monitoring svc/monitoring-kube-prometheus-prometheus 9090:9090
  kubectl port-forward -n tracing svc/jaeger-query 16686:16686

Browser URLs: http://localhost:8080, http://localhost:3000, http://localhost:9090, http://localhost:16686
Grafana password:
  kubectl get secret -n monitoring monitoring-grafana -o jsonpath='{.data.admin-password}' | base64 -d; echo
EOF
