config:
  configFile: |-
    provider="github"
    github_org="shoal-konst-fish"
    %{ if github_team != "" }github_team="${github_team}"%{ endif }
    http_address="0.0.0.0:4180"
    upstreams="file:///dev/null"
    email_domains=["*"]
    skip_provider_button=true
    cookie_domains=[".konst.fish"]
    whitelist_domains=[".konst.fish:*"]
    set_xauthrequest=true
    pass_user_headers=true
ingress:
  enabled: true
  className: nginx
  hosts:
    - ${domain}
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-dns"
    external-dns.alpha.kubernetes.io/target: "tetra.shoal.konst.fish"
    external-dns.alpha.kubernetes.io/hostname: "${domain}"
  tls:
    - secretName: oauth-${class}-tls
      hosts:
        - ${domain}

sessionStorage:
  type: redis
  redis:
    existingSecret: oauth2-proxy-${class}-redis
    standalone:
      connectionUrl: redis://oauth2-proxy-${class}-redis-headless:6379

redis:
  enabled: true
  architecture: standalone
  master:
    persistence:
      enabled: false

metrics:
  enabled: true
  serviceMonitor:
    enabled: true