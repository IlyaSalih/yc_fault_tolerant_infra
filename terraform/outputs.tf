output "bastion_public_ip" {
  value = module.compute.bastion_public_ip
}

output "bastion_internal_ip" {
  value = module.compute.bastion_internal_ip
}

output "web_internal_ips" {
  value = module.compute.web_internal_ips
}

output "alb_public_ip" {
  value = module.compute.alb_public_ip
}

output "prometheus_internal_ip" {
  value = module.monitoring.prometheus_internal_ip
}

output "grafana_public_ip" {
  value = module.monitoring.grafana_public_ip
}

output "grafana_internal_ip" {
  value = module.monitoring.grafana_internal_ip
}

output "elasticsearch_internal_ip" {
  value = module.logging.elasticsearch_internal_ip
}

output "kibana_public_ip" {
  value = module.logging.kibana_public_ip
}

output "kibana_internal_ip" {
  value = module.logging.kibana_internal_ip
}