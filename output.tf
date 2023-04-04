output "wp_lb_ip" {
  value = digitalocean_loadbalancer.public.ip
  description = "IP do LoadBalancer"
}

output "wp_vm_ips" {
  value = digitalocean_droplet.droplet_wp[*].ipv4_address
  description = "IP das VMs WordPress"
}

output "nfs_vm_ip" {
  value = digitalocean_droplet.droplet_nfs.ipv4_address
  description = "IP da VM NFS"
}

output "db_mysql_name" {
  value = digitalocean_database_cluster.db_mysql_wp.name
  description = "IP do DB MySql"
}

output "db_user" {
  value = digitalocean_database_user.user_db_mysql.name
  description = "Nome do DB User"  
}

output "db_user_pass" {
  value = digitalocean_database_user.user_db_mysql.password
  description = "Senha do User DB"
  sensitive = true
}