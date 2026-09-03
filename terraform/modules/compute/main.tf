# Образ ОС — Ubuntu 22.04 LTS из публичного каталога стандартных образов Yandex Cloud
data "yandex_compute_image" "ubuntu" {
  family    = "ubuntu-2204-lts"
  folder_id = "standard-images"
}

# --- Bastion host: единственная точка входа по SSH снаружи ---
# Не preemptible — это критичная точка доступа, не хотим, чтобы её
# вышибло облако в неподходящий момент.
resource "yandex_compute_instance" "bastion" {
  name        = "bastion"
  zone        = var.zone_a
  platform_id = "standard-v3"
  allow_stopping_for_update = true

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
    }
  }

  network_interface {
    subnet_id          = var.public_subnet_id
    nat                 = true
    security_group_ids = [var.sg_bastion_id]
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }
}

# --- Web-серверы: 2 ВМ в разных зонах, идентичный набор ---
resource "yandex_compute_instance" "web" {
  count       = 2
  name        = "web-${count.index == 0 ? "a" : "b"}"
  zone        = count.index == 0 ? var.zone_a : var.zone_b
  platform_id = "standard-v3"

  # Preemptible — дешевле, безопасно для web-серверов: они легко
  # пересоздаются через Terraform, состояния не хранят.
  scheduling_policy {
    preemptible = var.web_preemptible
  }

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
    }
  }

  network_interface {
    subnet_id          = count.index == 0 ? var.private_subnet_a_id : var.private_subnet_b_id
    nat                 = false
    security_group_ids = [var.sg_web_id]
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }
}

