variable "ssh_public_key" {
  type = string
}

variable "zone_a" {
  type    = string
  default = "ru-central1-a"
}

variable "private_subnet_a_id" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "sg_prometheus_id" {
  type = string
}

variable "sg_grafana_id" {
  type = string
}

variable "monitoring_preemptible" {
  type    = bool
  default = true
}