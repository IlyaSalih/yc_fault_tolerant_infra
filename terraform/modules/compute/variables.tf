variable "ssh_public_key" {
  description = "Публичный SSH-ключ для доступа к ВМ (содержимое .pub файла)"
  type        = string
}

variable "network_id" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "private_subnet_a_id" {
  type = string
}

variable "private_subnet_b_id" {
  type = string
}

variable "sg_bastion_id" {
  type = string
}

variable "sg_web_id" {
  type = string
}

variable "sg_alb_id" {
  type = string
}

variable "zone_a" {
  type    = string
  default = "ru-central1-a"
}

variable "zone_b" {
  type    = string
  default = "ru-central1-b"
}

variable "web_preemptible" {
  description = "Использовать прерываемые (preemptible) ВМ для web-серверов"
  type        = bool
  default     = true
}