---
title: OpenTelemetry
draft: false
tags: [observability, observability/traces]
date: 2024-05-25
---

## Architecture

Tenants create Collectors using the [OpenTelemetry Operator](https://github.com/open-telemetry/opentelemetry-operator). todo expand

```mermaid
flowchart LR
    subgraph Tenant Namespace
    otel(OTel Collector)
    dep1(Deployments) -->|1| otel
    otelcrd{{OTel Collector CRD}} -.->|controls| otel
    isa([Ingest Service Account]) <-.-> otel
    end
    subgraph Kubernetes
    sar{{SubjectAccessReview}} --> isa
    end
    subgraph Operators
    otelop(OpenTelemetry Operator) --> otelcrd
    end
    subgraph Monitoring Namespace
    otel -->|2| tempo(Tempo)
    tempo <-->|3| sar
    end
```