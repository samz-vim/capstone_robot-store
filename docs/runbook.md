# Operations Runbook

## First response
1. `kubectl get pods -A`
2. `kubectl get events -A --sort-by=.lastTimestamp | tail -40`
3. `kubectl describe pod -n <namespace> <pod>`
4. `kubectl logs -n <namespace> <pod> --all-containers --tail=200`
5. If metrics-server is installed: `kubectl top nodes` and `kubectl top pods -A`

## Robot Shop unavailable
- Confirm pods are Ready in `robot-shop`.
- Inspect services and endpoints: `kubectl get svc,endpoints -n robot-shop`.
- Port-forward the actual frontend service name and port.
- Inspect dependent microservices and their logs.

## Monitoring unavailable
- Check `kubectl get pods,svc,pvc -n monitoring`.
- Inspect Prometheus/Grafana logs and PVC status.
- Read Grafana password from the `monitoring-grafana` secret.

## Logging unavailable
- Confirm Fluent Bit pods are running on nodes.
- Confirm the Loki service name/port matches the Fluent Bit output.
- Check Fluent Bit logs and use Grafana Explore to query Loki.

## Tracing unavailable
- Check Jaeger pods/services in `tracing`.
- Configure instrumented applications to export OTLP to `jaeger-collector.tracing.svc.cluster.local:4317` (gRPC) or port 4318 (HTTP).
- Installing Jaeger alone does not instrument applications or create traces.
