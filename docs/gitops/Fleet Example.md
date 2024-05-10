---
title: Fleet Example
draft: false
tags: [usage, fleet, gitops]
date: 2024-04-28
---

```yaml
apiVersion: fleet.cattle.io/v1alpha1
kind: GitRepo
metadata:
  labels:
    tenant: <tenant>
  name: <project>
  namespace: fleet-<tenant>
spec:
  branch: main
  paths:
    - /path/to/manifests
  repo: https://github.com/user/repo
  targetNamespace: <tenant>
  targets:
    - clusterName: tetra
```

[More Usage Examples](https://www.google.com/search?q=fleet+examples&sourceid=chrome&ie=UTF-8)