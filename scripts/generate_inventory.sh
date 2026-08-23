#!/usr/bin/env bash
# Генерирует ansible/inventory/hosts.yml на основе terraform output.
# Запускать из корня проекта: ./scripts/generate_inventory.sh

set -euo pipefail

cd "$(dirname "$0")/../terraform"

BASTION_IP=$(terraform output -raw bastion_public_ip)
WEB_IPS=$(terraform output -json web_internal_ips | jq -r '.[]')

WEB_A=$(echo "$WEB_IPS" | sed -n '1p')
WEB_B=$(echo "$WEB_IPS" | sed -n '2p')

cd ..

cat > ansible/inventory/hosts.yml << EOF
all:
  vars:
    ansible_user: ubuntu
    ansible_ssh_private_key_file: ~/.ssh/coursework_ed25519

  children:
    bastion:
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
EOF

echo "Inventory сгенерирован: ansible/inventory/hosts.yml"
echo "  bastion: ${BASTION_IP}"
echo "  web-a:   ${WEB_A}"
echo "  web-b:   ${WEB_B}"