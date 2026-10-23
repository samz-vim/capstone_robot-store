#!/usr/bin/env bash
set -u
for ns in robot-shop monitoring tracing; do
  echo "== $ns =="
  kubectl get pods,svc -n "$ns" 2>&1 || true
  echo
done
echo '== Recent cluster events =='
kubectl get events -A --sort-by=.lastTimestamp 2>/dev/null | tail -30 || true
