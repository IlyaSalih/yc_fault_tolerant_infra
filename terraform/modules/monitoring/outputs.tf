output "prometheus_internal_ip" {
  value = yandex_compute_instance.prometheus.network_interface[0].ip_address
}

output "grafana_public_ip" {
  value = yandex_compute_instance.grafana.network_interface[0].nat_ip_address
}

output "grafana_internal_ip" {
  value = yandex_compute_instance.grafana.network_interface[0].ip_address
}

output "prometheus_disk_id" {
  value = yandex_compute_instance.prometheus.boot_disk[0].disk_id
}

output "grafana_disk_id" {
  value = yandex_compute_instance.grafana.boot_disk[0].disk_id
}