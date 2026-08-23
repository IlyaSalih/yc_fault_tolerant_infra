variable "zone_a" {
  description = "Первая зона доступности"
  type        = string
  default     = "ru-central1-a"
}

variable "zone_b" {
  description = "Вторая зона доступности (для отказоустойчивости web-серверов)"
  type        = string
  default     = "ru-central1-b"
}

variable "private_cidr" {
  description = "CIDR приватной подсети в zone_a"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_cidr_b" {
  description = "CIDR приватной подсети в zone_b"
  type        = string
  default     = "10.0.2.0/24"
}

variable "public_cidr" {
  description = "CIDR публичной подсети"
  type        = string
  default     = "10.0.10.0/24"
}

variable "admin_ip_cidr" {
  description = "CIDR твоего IP для доступа к SSH bastion, Grafana, Kibana. Узнать: curl ifconfig.me и добавить /32"
  type        = string
}