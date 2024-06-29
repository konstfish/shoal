---
title: Helm CRD
draft: false
tags: [helm, gitops]
date: 2024-03-01
---

Rancher provides the ability to deploy [Helm Charts](https://helm.sh/docs/topics/charts/) using CRDs. `HelmChart` definitions contain the repository, chart, version & values, which are applied to the cluster by a temporary worker Pod. Any changes to the `HelmChart` CRD cause the creation of a new Pod to update the Chart in place.

## Architecture

```mermaid
flowchart TB
    subgraph cluster[Kubernetes Cluster]
    subgraph Namespace
    hccrd([HelmChart CRD]) -.-> helminstallpod(Helm Installer Pod)
    helminstallpod --> hc
    subgraph hc[Helm Chart]
    direction BT
    app[Application]
    conf[Config]
    end
    end
    end
```

## Usage

```yaml
apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
  name: elasticsearch
  namespace: tenant
spec:
  # chart source
  chart: elasticsearch
  repo: https://helm.elastic.co
  version: v8.5.1
  targetNamespace: tenant
  # values
  set:
    rbac.create: "true"
  valuesContent: |-
    resources:
      requests:
        cpu: "1000m"
        memory: "2Gi"
      limits:
        cpu: "1000m"
        memory: "2Gi"
```