#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../terraform"

BASTION_IP=$(terraform output -raw bastion_public_ip)
WEB_IPS=$(terraform output -json web_internal_ips | jq -r '.[]')
PROMETHEUS_IP=$(terraform output -raw prometheus_internal_ip)
GRAFANA_INTERNAL_IP=$(terraform output -raw grafana_internal_ip)
GRAFANA_PUBLIC_IP=$(terraform output -raw grafana_public_ip)

WEB_A=$(echo "$WEB_IPS" | sed -n '1p')
WEB_B=$(echo "$WEB_IPS" | sed -n '2p')

cd ..

cat > ansible/inventory/hosts.yml << INNER_EOF
all:
  vars:
    ansible_user: ubuntu
    ansible_ssh_private_key_file: ~/.ssh/coursework_ed25519

  children:
    bastion_host:
      hosts:
        bastion:
          ansible_host: ${BASTION_IP}
          ansible_ssh_common_args: "-o StrictHostKeyChecking=no"

    web:
      hosts:
        web-a:
          ansible_host: ${WEB_A}
        web-b:
          ansible_host: ${WEB_B}
      vars:
        ansible_ssh_common_args: >-
          -o StrictHostKeyChecking=no
          -o ProxyCommand="ssh -i ~/.ssh/coursework_ed25519 -o StrictHostKeyChecking=no -W %h:%p ubuntu@${BASTION_IP}"

    prometheus:
      hosts:
        prometheus-server:
          ansible_host: ${PROMETHEUS_IP}
      vars:
        ansible_ssh_common_args: >-
          -o StrictHostKeyChecking=no
          -o ProxyCommand="ssh -i ~/.ssh/coursework_ed25519 -o StrictHostKeyChecking=no -W %h:%p ubuntu@${BASTION_IP}"

    grafana:
      hosts:
        grafana-server:
          ansible_host: ${GRAFANA_INTERNAL_IP}
      vars:
        ansible_ssh_common_args: >-
          -o StrictHostKeyChecking=no
          -o ProxyCommand="ssh -i ~/.ssh/coursework_ed25519 -o StrictHostKeyChecking=no -W %h:%p ubuntu@${BASTION_IP}"
INNER_EOF

echo "Inventory сгенерирован: ansible/inventory/hosts.yml"
echo "  bastion:        ${BASTION_IP}"
echo "  web-a:          ${WEB_A}"
echo "  web-b:          ${WEB_B}"
echo "  prometheus:     ${PROMETHEUS_IP}"
echo "  grafana (int):  ${GRAFANA_INTERNAL_IP}"
echo "  grafana (pub):  ${GRAFANA_PUBLIC_IP}"
