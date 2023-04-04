terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.27.1"
    }
  }
}


# VPC do WordPress
# ****************************************************
resource "digitalocean_vpc" "vpc_tf" {
  name     = "vpc-wp-tf"
  region   = var.region
  ip_range = "10.0.0.0/24"
}
# ****************************************************


# Droplets
# ****************************************************

resource "digitalocean_droplet" "droplet_wp" {
  image    = "ubuntu-18-04-x64"
  name     = "droplet-wp-${count.index}"
  region   = var.region
  size     = "s-1vcpu-1gb"
  vpc_uuid = digitalocean_vpc.vpc_tf.id
  count    = var.wp_vm_count
  ssh_keys = [var.vms_ssh]
}

#Droplets para Storage dos dados para HA
resource "digitalocean_droplet" "droplet_nfs" {
  image    = "ubuntu-18-04-x64"
  name     = "droplet-nfs"
  region   = var.region
  size     = "s-1vcpu-1gb"
  vpc_uuid = digitalocean_vpc.vpc_tf.id
}

# ****************************************************


# DataBase MySql
# ****************************************************
resource "digitalocean_database_cluster" "db_mysql_wp" {
  name                 = "db-mysql-wp"
  engine               = "mysql"
  version              = "8"
  size                 = "db-s-1vcpu-1gb"
  region               = var.region
  node_count           = 1
  private_network_uuid = digitalocean_vpc.vpc_tf.id
}
# ****************************************************


#DataBase User
# ****************************************************
resource "digitalocean_database_user" "user_db_mysql" {
  cluster_id = digitalocean_database_cluster.db_mysql_wp.id
  name       = "wordpressuser"
}
# ****************************************************


# LoadBalancer
# ****************************************************
resource "digitalocean_loadbalancer" "public" {
  name   = "lb-wp"
  region = var.region

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"
  }

  healthcheck {
    port     = 80
    protocol = "http"
    path     = "/"
  }

  vpc_uuid = digitalocean_vpc.vpc_tf.id

  droplet_ids = digitalocean_droplet.droplet_wp[*].id
}

# ****************************************************



