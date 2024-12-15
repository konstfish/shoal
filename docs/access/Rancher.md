---
title: Rancher
draft: false
tags: [rancher, usage]
date: 2024-02-01
---

<link rel="stylesheet" type='text/css' href="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/devicon.min.css" />

<i class="devicon-rancher-original"></i>

[rancher.konst.fish](https://rancher.konst.fish)

## Getting a kubeconfig

Navigate to the Cluster Overview Page & download the kubeconfig for "tetra." This creates a temporary token which can be used to access the Kubernetes api through the rancher proxy.

![[kubeconfig.jpg]]

Set your namespace context using
`kubectl config set-context --current --namespace=<tenant-ns>`