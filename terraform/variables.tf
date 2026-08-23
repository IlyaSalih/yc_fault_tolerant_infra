variable "sa_key_file" {
  description = "Path to service account authorized key JSON"
  type        = string
  default     = "../key.json"
}

variable "cloud_id" {
  description = "Yandex Cloud cloud ID"
  type        = string
}

variable "folder_id" {
  description = "Yandex Cloud folder ID"
  type        = string
  default     = "b1gj8ulelf2vc83hfm2t"
}

variable "default_zone" {
  description = "Default availability zone"
  type        = string
  default     = "ru-central1-a"
}

variable "admin_ip_cidr" {
  description = "CIDR IP для SSH bastion, Grafana, Kibana"
  type        = string
}

variable "ssh_public_key" {
  description = "Публичный SSH-ключ для доступа к ВМ"
  type        = string
}