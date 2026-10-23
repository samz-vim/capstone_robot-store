# SLO and Error Budget — Starter

## Availability objective
- **SLI:** successful valid HTTP requests divided by all valid HTTP requests measured at the application edge.
- **Initial target:** 99.0% over a rolling 30-day window.
- **Error budget:** 1.0% unsuccessful requests over the same window.

## Latency objective
- **SLI:** proportion of requests completed in less than one second.
- **Initial target:** 95% under one second over 30 days.

These are proposed learning targets, not measured results. The default demo chart may not expose request metrics. Add an instrumented ingress or application metrics before claiming the SLO is being achieved.

## Error-budget response
1. Confirm the alert and user impact.
2. Check readiness, recent deployments, resource saturation, and dependencies.
3. If budget burn is rapid, pause risky releases and prioritize reliability work.
4. Record timeline, impact, cause, mitigation, and follow-up owners.
