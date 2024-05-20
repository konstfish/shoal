---
title: Helm CRD
draft: false
tags: [helm, gitops]
date: 2024-03-01
---

Deploy [Helm Charts](https://helm.sh/docs/topics/charts/) using CRDs.

## Usage

```yaml
apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
  name: promtail
  namespace: monitoring
spec:
  chart: promtail
  repo: https://grafana.github.io/helm-charts
  targetNamespace: monitoring
  version: v6.15.5
  set:
    serviceMonitor.enabled: "true"
  valuesContent: |-
    config:
      snippets:
        pipelineStages:
          - cri: {}
```