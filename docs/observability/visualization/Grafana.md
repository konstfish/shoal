---
title: Grafana
draft: false
tags: [observability, observability/visualization]
date: 2024-05-18
---

## Architecture

Using the [Grafana Operator](https://grafana.github.io/grafana-operator/) Tenants can self-manage instances of Grafana to Query the managed Observability services. 

## Usage

### Grafana Instance

```yaml
apiVersion: grafana.integreatly.org/v1beta1
kind: Grafana
metadata:
  labels:
    app: grafana
  name: grafana
spec:
  config:
    analytics:
      check_for_updates: 'false'
      reporting_enabled: 'false'
    auth:
      disable_login_form: 'true'
      disable_signout_menu: 'true'
    auth.anonymous:
      enabled: 'false'
    auth.proxy:
      enabled: 'true'
      auto_sign_up: 'true'
      enable_login_token: 'false'
      header_name: X-Auth-Request-Email
      headers: >-
        Name:X-Auth-Request-User Email:X-Auth-Request-Email
    users:
      auto_assign_org_role: Admin
      default_theme: light
    log:
      mode: console
    security:
      admin_password: start
      admin_user: root
  deployment:
    spec:
      template:
        spec:
          containers:
            - name: grafana
              image: grafana/grafana:11.0.0
```

Expose it using an [[Ingress Nginx]] with [[Zero Trust]].

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: grafana-ingress
  annotations:
    nginx.ingress.kubernetes.io/auth-signin: https://sso.konst.fish/oauth2/start?rd=$scheme://$host$request_uri
    nginx.ingress.kubernetes.io/auth-url: https://sso.konst.fish/oauth2/auth
    nginx.ingress.kubernetes.io/auth-response-headers: X-Auth-Request-Email,X-Auth-Request-Groups,X-Auth-Request-User
spec:
  ingressClassName: nginx
  rules:
  - host: "grafana-tenant.app.konst.fish"
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: grafana-service
            port:
              number: 3000
```

### Dashboards

todo

```yaml

```