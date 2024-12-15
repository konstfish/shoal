---
title: Showcase
draft: false
tags: [usage]
date: 2024-06-02
---

To demonstrate some cluster functionality, I set up a demo application with 4 microservices, a web server & a database/cache (Redis). 

The application can be accessed using the appdomain on https://aquarium.app.konst.fish/. ([Ingress Source](https://github.com/konstfish/aquarium/blob/main/kubernetes/ingress/ingress.yaml)) The source code & Kubernetes manifests are in this [git repo](https://github.com/konstfish/aquarium). 

The app also features complete observability, part of the platforms offered functionality, which can be viewed here https://showcase-grafana.app.konst.fish/ (This is behind [[Zero Trust]], all members of the GitHub Org are authorized)

## Architecture Graph

```mermaid
flowchart LR
    User ==> ing

    subgraph Monitoring Namespace
    lk(Loki)
    prom(Prometheus)
    tempo(Tempo)
    end

    subgraph sn [Showcase Namespace]
    ing{{Ingress}} ==> tank
    ing ==> tetra
    ing ==> butter
    ing ==> puffer

    tank(Tank) --> sprite(Sprite Service)
    sprite --> redis

    puffer(Puffer) --> tetra
    puffer --> butter

    tetra(Tetra) --> redis
    butter(Butterfly) --> redis

    redis(Redis) --> star    

    star(Starfish)

    otel(OTel Collector)
    tetra -.-> otel
    puffer -.-> otel
    star -.-> otel
    butter -.-> otel

    sm{{Service Monitor}} -.-> tetra
    sm -.-> puffer
    sm -.-> butter
    sm -.-> star
    end

    lk --> sn
    prom --> sm
    otel --> tempo
```