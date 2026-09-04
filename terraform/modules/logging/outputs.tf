output "elasticsearch_internal_ip" {
  value = yandex_compute_instance.elasticsearch.network_interface[0].ip_address
}

output "kibana_public_ip" {
  value = yandex_compute_instance.kibana.network_interface[0].nat_ip_address
}

output "kibana_internal_ip" {
  value = yandex_compute_instance.kibana.network_interface[0].ip_address
}

output "elasticsearch_disk_id" {
  value = yandex_compute_instance.elasticsearch.boot_disk[0].disk_id
}

output "kibana_disk_id" {
  value = yandex_compute_instance.kibana.boot_disk[0].disk_id
}