#!/usr/bin/env bash
set -euo pipefail
echo 'WARNING: this removes lab resources in namespaces robot-shop, monitoring, and tracing.'
read -r -p 'Type DELETE to continue: ' confirm
[[ "$confirm" == 'DELETE' ]] || { echo 'Cancelled.'; exit 0; }
helm uninstall robot-shop -n robot-shop 2>/dev/null || true
helm uninstall monitoring -n monitoring 2>/dev/null || true
helm uninstall loki -n monitoring 2>/dev/null || true
helm uninstall fluent-bit -n monitoring 2>/dev/null || true
kubectl delete namespace robot-shop monitoring tracing --ignore-not-found=true
echo 'Cleanup submitted. The Kubernetes cluster itself is not deleted.'
