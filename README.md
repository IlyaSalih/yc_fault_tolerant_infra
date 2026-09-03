# 1. Проверить VPN/роутер — трафик к Yandex Cloud должен идти БЕЗ VPN
curl ifconfig.me   # сверить IP с admin_ip_cidr в terraform.tfvars, если изменился — поправить

# 2. Перейти в проект, применить инфраструктуру
cd ~/Projects/coursework/terraform
terraform apply     # confirm: yes

# 3. Посмотреть новые IP и обновить inventory
terraform output
cd ~/Projects/coursework
./scripts/generate_inventory.sh

# 4. Проверить связь со всеми хостами (bastion, web-a/b, prometheus, grafana)
ansible all -m ping

# 5. Прогнать существующие плейбуки (nginx + exporters на web-серверах)
ansible-playbook ansible/playbooks/site.yml

# 6. Проверить сайт через ALB
curl -v http://$(cd terraform && terraform output -raw alb_public_ip)