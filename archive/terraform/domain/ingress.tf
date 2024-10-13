resource "cloudflare_record" "default" {
  zone_id = var.cloudflare_zone_id
  name    = var.record_name
  value   = var.record_value
  type    = var.record_type
  ttl     = 3600
}
