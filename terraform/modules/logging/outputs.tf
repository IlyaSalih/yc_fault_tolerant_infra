output "elasticsearch_internal_ip" {
  value = yandex_compute_instance.elasticsearch.network_interface[0].ip_address
}

output "kibana_public_ip" {
  value = yandex_compute_instance.kibana.network_interface[0].nat_ip_address
}

output "kibana_internal_ip" {
  value = yandex_compute_instance.kibana.network_interface[0].ip_address
}