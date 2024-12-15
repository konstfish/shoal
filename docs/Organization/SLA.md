---
title: Shoal Platform Service Level Agreement
draft: false
tags: [org]
date: 2024-12-15
---

# Shoal Platform Service Level Agreement (SLA)

## 1. Service Overview

This Service Level Agreement ("Agreement") describes the service levels and support commitments for Shoal ("the Service"). The Service provides container orchestration and related cloud-native capabilities to multiple tenants in a shared infrastructure environment.

## 2. Service Commitments

### 2.1 Service Availability

The Service commits to an uptime of 98.36% measured on a yearly basis, which allows for a maximum of 48 hours (2 days) of downtime per year. This commitment excludes scheduled maintenance windows.

Calculation: (Total Minutes in Year - Downtime Minutes) / Total Minutes in Year × 100

### 2.2 Resource Guarantees

Each tenant namespace is guaranteed the following resources:
- Compute: 2 CPU cores
- Memory: 2GB RAM
- Storage: 30GB SSD persistent storage

### 2.3 Platform Services

The following platform services are included:
- Managed Platform & Access, see [[Rancher]] & [[Zero Trust]]
- Load-balanced ingress controllers, see [[Ingress]]
- Automated TLS certificate management and renewal, see [[cert-manager]]
- GitOps functionality, see [[GitOps]]
- Secret Management, see [[Sealed Secrets]]
- Observability stack:
  - Metrics collection and storage, see [[Prometheus]]
  - Log aggregation and retention, see [[Loki]]
  - Distributed tracing, see [[Tempo]] & [[OpenTelemetry]]
  - Visualization (Tenant & Cluster Scope), see [[Grafana]]
- Serverless container deployment via Knative, see [[Knative]]
- Optional service mesh implementation (upon request), see [[Istio]]

## 3. Service Exclusions

The following are excluded from SLA calculations:
- Scheduled maintenance (announced 12 hours in advance)
- Issues caused by tenant applications or misconfigurations
- Exceeding resource quotas
- Network issues outside the platform's control

## 4. Support Response Times

### 4.1 Incident Priority Levels

- P1 (Critical): Service unavailable - Response within 2 hour
- P2 (High): Service degraded - Response within 4 hours
- P3 (Medium): Non-critical component failure - Response within 8 hours
- P4 (Low): General inquiries - Response within 24 hours

### 4.2 Maintenance Windows

Scheduled maintenance will be performed during the following windows:
- Regular maintenance: Sundays 00:00-05:00 GMT+1
- Emergency maintenance: As required, with best-effort notification

## 5. Tenant Responsibilities

Tenants are responsible for:
- Managing their application deployments
- Monitoring resource usage within allocated quotas
- Maintaining security of their credentials and access tokens
- Backing up application-specific data
- Following platform security guidelines

## 6. Monitoring and Reporting

### 6.1 Service Metrics

The following metrics will be monitored and made available:
- Platform uptime
- Resource utilization
- Response times
- Error rates

## 7. Terms and Termination

This SLA is part of the main service agreement and may be updated with 30 days notice. All changes will be communicated to tenants in writing.