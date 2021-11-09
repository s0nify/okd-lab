variable "MCS_PASSWORD" {
  type = string
}

variable "MCS_USERNAME" {
  type = string
}

variable "MCS_PROJECT_ID" {
  type = string
}


variable "SSH_KEY" {
  type = string
}

terraform {
    required_providers {
        openstack = {
            source = "terraform-provider-openstack/openstack"
            version = "1.33.0"
        }
        
        mcs = {
            source = "MailRuCloudSolutions/mcs"
            version = "~> 0.4.2"
        }
    }
}

provider "openstack" {
    # Your user account.
    user_name = var.MCS_USERNAME

    # The password of the account
    password = var.MCS_PASSWORD

    # The tenant token can be taken from the project Settings tab - > API keys.
    # Project ID will be our token.
    tenant_id = var.MCS_PROJECT_ID

    # The indicator of the location of users.
    user_domain_id = "users"

    # API endpoint
    # Terraform will use this address to access the VK Cloud Solutions api.
    auth_url = "https://infra.mail.ru:35357/v3/"

    # use octavia to manage load balancers
    use_octavia = true
    
    # Region name
    region = "RegionOne"
}

provider "mcs" {
    # Your user account.
    username = "givemeparachute@gmail.com"

    # The password of the account
    password = "YOUR_PASSWORD"

    # The tenant token can be taken from the project Settings tab - > API keys.
    # Project ID will be our token.
    project_id = "da50a396acf14358a85377d17e46b613"
    
    # Region name
    region = "RegionOne"
}

resource "openstack_compute_keypair_v2" "ssh" {
  # Название ssh ключа,
  # Данный ключ будет отображаться в разделе
  # Облачные вычисления -> Ключевые пары
  name = "terraform_ssh_key"
  
  # Путь до публичного ключа
  # В примере он находится в одной директории с main.tf
  public_key = var.SSH_KEY
}

resource "openstack_compute_secgroup_v2" "rules" {
  name = "terraform__security_group"
  description = "security group for terraform instance"
  rule {
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
  rule {
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
  rule {
    from_port = -1
    to_port = -1
    ip_protocol = "icmp"
    cidr = "0.0.0.0/0"
  }
}


module "servers" {
  source = "./okd-services"
}

resource "openstack_networking_network_v2" "network_1" {
  name           = "int-okd-lab-1"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_1" {
  name       = "sub-okd-lab-1"
  network_id = "${openstack_networking_network_v2.network_1.id}"
  cidr       = "192.168.199.0/24"
  ip_version = 4
}
resource "openstack_compute_secgroup_v2" "secgroup_1" {
  name        = "secgroup_1"
  description = "a security group"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}
