---
title: NGINX Ingress
draft: false
tags: [ingress, nginx]
date: 2024-03-01
---

We're using the [Ingress NGINX Controller](https://github.com/kubernetes/ingress-nginx).

## Architecture

```mermaid
flowchart LR

    web[Web] --> nginx

    subgraph cluster[Kubernetes Cluster]
    direction LR
    subgraph nginx[NGINX Ingress]
    end

    subgraph tn[Tenant Namespace]
    svc{{Service}}
    ing(Ingress) --> svc
    end

    nginx --> ing
    end
```

## Usage

See [[cert-manager]] to secure Ingresses with TLS & [[DNS]] to correctly point records to the cluster.

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
spec:
  ingressClassName: nginx
  rules:
  - host: "example.appdomain.konst.fish"
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: example-service
            port:
              number: 3000
```