---
title: Loki
draft: false
tags: [observability, observability/logging]
date: 2024-05-18
---

## Architecture

Built using the [Loki](https://artifacthub.io/packages/helm/grafana/loki) & [Promtail](https://artifacthub.io/packages/helm/grafana/promtail) Helm Charts. Logs are collected by Promtail Pods & [automatically assigned](https://grafana.com/docs/loki/latest/send-data/promtail/stages/tenant/) to a tenant based on the namespace. Tenants query Loki using their [OrgID](https://grafana.com/docs/loki/latest/operations/multi-tenancy/).

```mermaid
flowchart LR
    A[Tenant] -->|1| grafana(Grafana)
    subgraph tn[Tenant Namespace]
    qsa([Query Service Account]) <-.-> grafana
    end
    subgraph Monitoring Namespace
    subgraph Loki Query Frontend
    grafana -->|2| krp(kube-rbac-proxy)
    end
    krp -->|7| quer
    subgraph Loki
    inge(Ingester)
    inge --> s3
    quer(Querier) --> s3
    end
    end
    tn -->|Logs| promt(Promtail)
    promt --> inge
    s3[(BackBlaze B2)]
    subgraph Kubernetes
    krp -->|3| sar{{SubjectAccessReview}}
    sar <-->|4| qsa
    sar -->|5| krp
    end
```