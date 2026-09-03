data "yandex_compute_image" "ubuntu" {
  family    = "ubuntu-2204-lts"
  folder_id = "standard-images"
}

resource "yandex_compute_instance" "elasticsearch" {
  name        = "elasticsearch"
  zone        = var.zone_a
  platform_id = "standard-v3"

  scheduling_policy {
    preemptible = var.logging_preemptible
  }

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 30
    }
  }

  network_interface {
    subnet_id          = var.private_subnet_a_id
    nat                = false
    security_group_ids = [var.sg_elasticsearch_id]
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }
}

resource "yandex_compute_instance" "kibana" {
  name        = "kibana"
  zone        = var.zone_a
  platform_id = "standard-v3"

  scheduling_policy {
    preemptible = var.logging_preemptible
  }

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 15
    }
  }

  network_interface {
    subnet_id          = var.public_subnet_id
    nat                = true
    security_group_ids = [var.sg_kibana_id]
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }
}