---
title: Observability Usage
draft: false
tags: [observability, usage]
date: 2024-03-01
---

Each managed observability offering requires a Service Account holding the correct permissions to interface with the querier/ingester frontends. The [[Showcase|Showcase Namespace]] demonstrates how to use the entire monitoring stack.

## Service Account

### Role & Binding

Create a Role which holds get permissions on the namespace/metrics resource.

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: namespace-metrics
rules:
- apiGroups: [""]
  resources:
  - namespace/metrics
  verbs: ["get"]
```

Create a Service Account & grant the role to it.

```yaml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: grafana-ds-sa
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: namespace-metrics
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: namespace-metrics
subjects:
- kind: ServiceAccount
  name: grafana-ds-sa
  namespace: showcase
```

Finally, create a secret, which dynamically populates with a JWT, which can be used to make requests to the monitoring infrastructure.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: grafana-ds-sa-token
  annotations:
    kubernetes.io/service-account.name: grafana-ds-sa
type: kubernetes.io/service-account-token
```

Confirm a token was created in the secret by running `kubectl get secret grafana-ds-sa-token -o jsonpath='{.data.token}'`