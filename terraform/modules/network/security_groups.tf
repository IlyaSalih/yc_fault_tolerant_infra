# --- Bastion: единственная точка входа по SSH снаружи ---
resource "yandex_vpc_security_group" "bastion" {
  name       = "sg-bastion"
  network_id = yandex_vpc_network.this.id

  ingress {
    protocol       = "TCP"
    description    = "SSH from admin IP"
    port           = 22
    v4_cidr_blocks = [var.admin_ip_cidr]
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- Web servers (nginx) ---
resource "yandex_vpc_security_group" "web" {
  name       = "sg-web"
  network_id = yandex_vpc_network.this.id

  ingress {
    protocol          = "TCP"
    description       = "SSH from bastion"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion.id
  }

  ingress {
    protocol          = "TCP"
    description       = "HTTP from ALB healthchecks"
    port              = 80
    predefined_target = "loadbalancer_healthchecks"
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTP from private subnets (ALB backend traffic)"
    port           = 80
    v4_cidr_blocks = [var.private_cidr, var.private_cidr_b]
  }

    ingress {
    protocol          = "TCP"
    description       = "HTTP from ALB itself (actual proxied requests, not just healthchecks)"
    port              = 80
    security_group_id = yandex_vpc_security_group.alb.id
  }

  ingress {
    protocol       = "TCP"
    description    = "Node Exporter + Nginx Log Exporter scrape from Prometheus subnet"
    from_port      = 9100
    to_port        = 9113
    v4_cidr_blocks = [var.private_cidr, var.private_cidr_b]
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- Prometheus ---
resource "yandex_vpc_security_group" "prometheus" {
  name       = "sg-prometheus"
  network_id = yandex_vpc_network.this.id

  ingress {
    protocol          = "TCP"
    description       = "SSH from bastion"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion.id
  }

  ingress {
    protocol       = "TCP"
    description    = "Prometheus UI/API from Grafana subnet"
    port           = 9090
    v4_cidr_blocks = [var.public_cidr]
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- Grafana ---
resource "yandex_vpc_security_group" "grafana" {
  name       = "sg-grafana"
  network_id = yandex_vpc_network.this.id

  ingress {
    protocol          = "TCP"
    description       = "SSH from bastion"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion.id
  }

  ingress {
    protocol       = "TCP"
    description    = "Grafana web UI"
    port           = 3000
    v4_cidr_blocks = [var.admin_ip_cidr]
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- Elasticsearch ---
resource "yandex_vpc_security_group" "elasticsearch" {
  name       = "sg-elasticsearch"
  network_id = yandex_vpc_network.this.id

  ingress {
    protocol          = "TCP"
    description       = "SSH from bastion"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion.id
  }

  ingress {
    protocol       = "TCP"
    description    = "Filebeat/Kibana access to Elasticsearch API"
    port           = 9200
    v4_cidr_blocks = [var.private_cidr, var.private_cidr_b, var.public_cidr]
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- Kibana ---
resource "yandex_vpc_security_group" "kibana" {
  name       = "sg-kibana"
  network_id = yandex_vpc_network.this.id

  ingress {
    protocol          = "TCP"
    description       = "SSH from bastion"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion.id
  }

  ingress {
    protocol       = "TCP"
    description    = "Kibana web UI"
    port           = 5601
    v4_cidr_blocks = [var.admin_ip_cidr]
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- Application Load Balancer ---
resource "yandex_vpc_security_group" "alb" {
  name       = "sg-alb"
  network_id = yandex_vpc_network.this.id

  ingress {
    protocol       = "TCP"
    description    = "HTTP from internet"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol           = "TCP"
    description        = "ALB healthcheck range (required by Yandex ALB)"
    from_port          = 0
    to_port             = 65535
    predefined_target  = "loadbalancer_healthchecks"
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}