# Capstone Project 2 — Kubernetes Microservices Observability

A starter project for deploying the Robot Shop microservices demo to an existing Kubernetes cluster and adding monitoring, logs, alerts, and a tracing backend.

## Included
- Robot Shop Helm deployment
- Prometheus + Grafana (`kube-prometheus-stack`)
- Loki + Fluent Bit starter configuration for centralized logs
- Jaeger all-in-one tracing backend
- Kubernetes alert rules, SLO starter, runbook, and postmortem template
- Shell scripts for prerequisite checks, installation, verification, access, and cleanup

> **Important:** This is a learning/lab package, not a production-ready deployment. Helm chart names, values, and service names can change upstream. Review `helm show values` and `kubectl get svc -n <namespace>` if a command differs in your cluster. Jaeger does not generate traces by itself: application services must be instrumented/configured to export OTLP. The Robot Shop chart may not expose all app-level Prometheus metrics without extra instrumentation.

## Prerequisites
- A running Kubernetes cluster and a working `kubectl` context
- Helm 3
- Recommended for the full stack: 4 vCPU and 8 GB RAM or more
- A StorageClass is recommended, although persistence is disabled for this disposable lab configuration

This package **does not create an AWS cluster** and does not automatically provision cloud infrastructure or incur AWS costs. It deploys into the currently selected Kubernetes context. Check it before running:

```bash
kubectl config current-context
kubectl get nodes -o wide
```

## Install
From the extracted project directory:

```bash
chmod +x scripts/*.sh
./scripts/00-check-prerequisites.sh
./scripts/10-deploy-robot-shop.sh
./scripts/20-deploy-observability.sh
./scripts/30-verify.sh
```

The installs can take several minutes. Watch pods with `kubectl get pods -A -w`.

## Access services
Run these commands in separate terminals (or run only the service you need):

```bash
# Find the Robot Shop frontend service name first:
kubectl get svc -n robot-shop
# Example command; adjust the service name/port to match the output:
kubectl port-forward -n robot-shop svc/robot-shop 8080:8080

kubectl port-forward -n monitoring svc/monitoring-grafana 3000:80
kubectl port-forward -n monitoring svc/monitoring-kube-prometheus-prometheus 9090:9090
kubectl port-forward -n tracing svc/jaeger-query 16686:16686
```

Open `http://localhost:8080`, `http://localhost:3000`, `http://localhost:9090`, and `http://localhost:16686`. The Robot Shop service name may differ; use `kubectl get svc -n robot-shop` to verify. Grafana username is `admin`; read the configured password using:

```bash
kubectl get secret -n monitoring monitoring-grafana -o jsonpath='{.data.admin-password}' | base64 -d; echo
```

The lab values set a sample Grafana password `ChangeMe-Lab-Only-123!`; change it before use and never use that password outside a disposable lab.

## Verify and capture screenshots
Useful evidence for your report/LinkedIn project post:
1. `kubectl get nodes -o wide`
2. `kubectl get pods -A`
3. Robot Shop website open in browser
4. Grafana dashboard with Prometheus data
5. Loki logs in Grafana Explore (after verifying Fluent Bit output)
6. Jaeger UI (traces appear only when a compatible service exports them)
7. Alert rules visible in Prometheus

## Troubleshooting
- **Pending / OOMKilled:** check `kubectl describe pod -n <namespace> <pod>` and `kubectl get events -A --sort-by=.lastTimestamp`; increase node resources or disable optional components.
- **ImagePullBackOff:** inspect pod events and confirm registry connectivity/image tags.
- **PVC pending:** check `kubectl get storageclass` and `kubectl get pvc -A`.
- **Robot Shop service mismatch:** run `kubectl get svc -n robot-shop` and port-forward the actual frontend service/port.
- **No logs in Loki:** inspect Fluent Bit pod logs and compare its Loki host with `kubectl get svc -n monitoring`.
- **No traces in Jaeger:** configure the application to export OTLP to `jaeger-collector.tracing.svc.cluster.local:4317` (gRPC) or port 4318 (HTTP); a backend alone is not instrumentation.
- **Helm chart mismatch:** check `helm repo list`, `helm search repo robot-shop`, and the upstream project instructions before changing chart names.

## Cleanup
Run `./scripts/90-cleanup.sh` and type `DELETE` when prompted. It deletes the lab namespaces `robot-shop`, `monitoring`, and `tracing`; it does not delete the cluster. Review the script before running.
