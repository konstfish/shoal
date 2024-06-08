---
title: Prometheus
draft: false
tags: [observability, observability/metrics]
date: 2024-05-18
---

## Architecture

Built with the [Prometheus Operator](https://prometheus-operator.dev/). Metrics are [collected](https://medium.com/@helia.barroso/a-guide-to-service-discovery-with-prometheus-operator-how-to-use-pod-monitor-service-monitor-6a7e4e27b303) from every namespace by a Cluster Scope Prometheus Instance. High availibility is managed through [Thanos](https://thanos.io/). Tenants query metrics through central multi-tenancy enabled query endpoint built with [kube-rbac-proxy](https://github.com/brancz/kube-rbac-proxy) and [prom-label-proxy](https://github.com/prometheus-community/prom-label-proxy).

```mermaid
flowchart LR
    A[Tenant] -->|1| grafana(Grafana)
    subgraph Tenant Namespace
    sm([ServiceMonitor]) --> dep(Deployments)
    qsa([Query Service Account]) <-.-> grafana
    end
    sm <-.-> Prometheus
    subgraph Monitoring Namespace
    subgraph Thanos Query Frontend
    grafana -->|2| krp(kube-rbac-proxy)
    krp -->|6| plp(prom-label-proxy)
    end
    plp -->|7| Prometheus
    subgraph Prometheus
    thanos(Thanos) --> prom(Prometheus TSDB)
    thanos --> s3[(BackBlaze B2)]
    end
    end
    subgraph Kubernetes
    krp -->|3| sar{{SubjectAccessReview}}
    sar <-->|4| qsa
    sar -->|5| krp
    end
```

Metrics are stored within the Prometheus TSDB for 7 days. Thanos retains them for 30 days, then downsamples points to 5 minute intervals at before 60 days & 1 hour after.