output "bastion_public_ip" {
  value = module.compute.bastion_public_ip
}

output "bastion_internal_ip" {
  value = module.compute.bastion_internal_ip
}

output "web_internal_ips" {
  value = module.compute.web_internal_ips
}

output "alb_public_ip" {
  value = module.compute.alb_public_ip
}