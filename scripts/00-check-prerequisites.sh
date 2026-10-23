#!/usr/bin/env bash
set -euo pipefail
for cmd in kubectl helm; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "ERROR: $cmd is required in PATH" >&2; exit 1; }
done
echo '== Client versions =='
kubectl version --client
helm version --short
echo '== Current context (verify this is the intended cluster) =='
kubectl config current-context
echo '== Nodes =='
kubectl get nodes -o wide
