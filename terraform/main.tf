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
    user_name = var.MCS_USERNAME
    password = var.MCS_PASSWORD
    tenant_id = var.MCS_PROJECT_ID
    user_domain_id = "users"
    auth_url = "https://infra.mail.ru:35357/v3/"
    use_octavia = true
    region = "RegionOne"
}

provider "mcs" {
    username = "givemeparachute@gmail.com"
    password = "YOUR_PASSWORD"
    project_id = "da50a396acf14358a85377d17e46b613"
    region = "RegionOne"
}

#resource "openstack_compute_keypair_v2" "ssh" {
# name = "terraform_ssh_key"
#  public_key = var.SSH_KEY
#}

resource "openstack_networking_network_v2" "okd-network" {
  name           = "okd-network"
  admin_state_up = "true"
}

resource "openstack_networking_subnetpool_v2" "okd-subnetpool" {
  name     = "okd-subnetpool"
  prefixes = ["192.168.199.0/24"]
}

resource "openstack_networking_subnet_v2" "okd-subnet" {
  name          = "subnet_1"
  cidr          = "192.168.199.0/24"
  network_id    = "${openstack_networking_network_v2.okd-network.id}"
  subnetpool_id = "${openstack_networking_subnetpool_v2.okd-subnetpool.id}"
}

resource "openstack_compute_instance_v2" "master" {
  name            = "master-${count.index+4}"
  count           = var.number_of_masters
  flavor_name     = "Basic-1-1-10"
#  key_pair        = openstack_compute_keypair_v2.ssh.name
  config_drive    = true
#  image_name      = openstack_images_image_v2.fedoracore.name
  image_id = "cd733849-4922-4104-a280-9ea2c3145417"

  network {
    name = "${openstack_networking_network_v2.okd-network.name}"
#	fixed_ip_v4 = "192.168.199.${9+1}"
#    port        = "${openstack_networking_port_v2.okd-master-port.*.id[count.index]}"
  }
}