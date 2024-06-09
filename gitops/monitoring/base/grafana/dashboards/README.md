# multitenant usage dashboards

## loki

`sum(loki_distributor_bytes_received_total{tenant="showcase"})`

`sum(rate(loki_distributor_bytes_received_total{tenant="showcase"}[1h]))`