---
title: DNS
draft: false
tags: [ingress, dns]
date: 2024-03-01
---

To use another domain besides `*.app.konst.fish`, create a CNAME record that points to the clusters canonical domain `app.konst.fish`. The [[Ingress Nginx]] will then correctly route traffic originating from the custom domain. To obtain a certificate, see [[cert-manager]].