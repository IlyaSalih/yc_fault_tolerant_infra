output "bastion_public_ip" {
  value = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
}

output "bastion_internal_ip" {
  value = yandex_compute_instance.bastion.network_interface[0].ip_address
}

output "web_internal_ips" {
  value = [for i in yandex_compute_instance.web : i.network_interface[0].ip_address]
}

output "alb_public_ip" {
  value = yandex_alb_load_balancer.this.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
}

output "bastion_disk_id" {
  value = yandex_compute_instance.bastion.boot_disk[0].disk_id
}

output "web_disk_ids" {
  value = [for w in yandex_compute_instance.web : w.boot_disk[0].disk_id]
}