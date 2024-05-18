---
title: Zero Trust
draft: false
tags: [security, ingress]
date: 2024-03-01
---

https://sso.konst.fish is an [OAuth2 Proxy](https://github.com/oauth2-proxy/oauth2-proxy) which authorizes any member of the shoal-konst-fish GitHub Org.

## Architecture

```mermaid
flowchart TD
    A[Web] --> ing(Ingress)
    subgraph OAuth2 Flow
    ing -->|1| sso[sso.konst.fish]
    sso -->|2| gh{{GitHub IdP}}
    gh -->|3| sso
    sso -->|4| ing
    end
    ing -->|5| srv(Service)
```

## Usage

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-behind-auth
  annotations:
    nginx.ingress.kubernetes.io/auth-signin: https://sso.konst.fish/oauth2/start?rd=$scheme://$host$request_uri
    nginx.ingress.kubernetes.io/auth-url: https://sso.konst.fish/oauth2/auth
    nginx.ingress.kubernetes.io/auth-response-headers: X-Auth-Request-Email,X-Auth-Request-Groups,X-Auth-Request-User
```

