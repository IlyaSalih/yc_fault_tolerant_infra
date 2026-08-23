resource "yandex_vpc_network" "this" {
  name = "coursework-network"
}

# NAT Gateway — нужен, чтобы ВМ в приватной подсети могли ходить в интернет
# (обновления, установка Filebeat/exporters), не имея публичного IP.
resource "yandex_vpc_gateway" "nat" {
  name = "coursework-nat-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "private" {
  network_id = yandex_vpc_network.this.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id          = yandex_vpc_gateway.nat.id
  }
}

# Приватная подсеть — web-серверы, Prometheus, Elasticsearch
resource "yandex_vpc_subnet" "private" {
  name           = "coursework-private-a"
  zone           = var.zone_a
  network_id     = yandex_vpc_network.this.id
  v4_cidr_blocks = [var.private_cidr]
  route_table_id = yandex_vpc_route_table.private.id
}

# Вторая приватная подсеть в другой зоне — для второго web-сервера (отказоустойчивость)
resource "yandex_vpc_subnet" "private_b" {
  name           = "coursework-private-b"
  zone           = var.zone_b
  network_id     = yandex_vpc_network.this.id
  v4_cidr_blocks = [var.private_cidr_b]
  route_table_id = yandex_vpc_route_table.private.id
}

# Публичная подсеть — Grafana, Kibana, ALB, bastion
resource "yandex_vpc_subnet" "public" {
  name           = "coursework-public-a"
  zone           = var.zone_a
  network_id     = yandex_vpc_network.this.id
  v4_cidr_blocks = [var.public_cidr]
}