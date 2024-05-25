---
title: Tempo
draft: false
tags: [observability, observability/traces]
date: 2024-05-24
---

## Architecture

Multi-tenant [Tempo](https://grafana.com/oss/tempo/) Instance built with the [Tempo Operator](https://github.com/grafana/tempo-operator). Traces can be queried through the Querier Frontend, which is a [kube-rbac-proxy](https://github.com/brancz/kube-rbac-proxy). The Ingester frontend is built the same way, only allowing service account tokens from the correct namespace. see [[OpenTelemetry]] for more information on the [OTel Collector](https://opentelemetry.io/docs/collector/).

```mermaid
flowchart LR
    A[Tenant] -->|1| grafana(Grafana)
    subgraph Tenant Namespace
    dep(Deployments) ==>|1| otel(OTel Collector)
    isa([Ingest Service Account]) <-.-> otel
    qsa([Query Service Account]) <-.-> grafana
    end
    subgraph Monitoring Namespace
    subgraph Tempo Querier Frontend
    grafana -->|2| krp(kube-rbac-proxy)
    end
    subgraph Tempo Ingester Frontend
    otel ==>|2| ikrp(kube-rbac-proxy)
    end
    subgraph Tempo
    dist(Distributor) --> ing(Ingester)
    ing --> s3[(BackBlaze B2)]
    querf(Query Frontend) --> quer
    quer(Querier) --> s3
    comp(Compactor) --> s3
    end
    ikrp --> dist
    krp --> querf
    end
    subgraph Kubernetes
    krp -->|3| sar{{SubjectAccessReview}}
    sar <-->|4| qsa
    sar <==>|3| isa
    sar -->|5| krp
    end
```