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

## Usage

No work from the Tenant's side, as logs are automatically collected. To read them, first create a Service Account as described in [[Observability Usage]]. Then create a [[Grafana|Grafana Instance]] & a Loki `GrafanaDataSource`.

```yaml
apiVersion: grafana.integreatly.org/v1beta1
kind: GrafanaDatasource
metadata:
  name: logs
  labels:
    app: grafana
spec:
  instanceSelector:
    matchLabels:
      app: grafana
  valuesFrom:
    - targetPath: secureJsonData.httpHeaderValue1
      valueFrom:
        secretKeyRef:
          key: token
          name: grafana-ds-sa-token
  datasource:
    name: logs
    type: loki
    uid: loki1
    access: proxy
    # central managed loki querier
    url: "https://loki-querier-frontend.monitoring.svc:3100/"
    isDefault: false
    editable: false
    jsonData:
      # pass the Service Account JWT from the secret
      httpHeaderName1: Authorization
      # & the namespace 
      httpHeaderName2: X-Scope-OrgID
      queryTimeout: 5m
      timeout: 60
      manageAlerts: false
      tlsSkipVerify: true
    secureJsonData:
      httpHeaderValue1: "Bearer ${token}"
      httpHeaderValue2: "<tenant>"
```