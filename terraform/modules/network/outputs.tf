output "network_id" {
  value = yandex_vpc_network.this.id
}

output "private_subnet_a_id" {
  value = yandex_vpc_subnet.private.id
}

output "private_subnet_b_id" {
  value = yandex_vpc_subnet.private_b.id
}

output "public_subnet_id" {
  value = yandex_vpc_subnet.public.id
}

output "sg_bastion_id" {
  value = yandex_vpc_security_group.bastion.id
}

output "sg_web_id" {
  value = yandex_vpc_security_group.web.id
}

output "sg_prometheus_id" {
  value = yandex_vpc_security_group.prometheus.id
}

output "sg_grafana_id" {
  value = yandex_vpc_security_group.grafana.id
}

output "sg_elasticsearch_id" {
  value = yandex_vpc_security_group.elasticsearch.id
}

output "sg_kibana_id" {
  value = yandex_vpc_security_group.kibana.id
}

output "sg_alb_id" {
  value = yandex_vpc_security_group.alb.id
}