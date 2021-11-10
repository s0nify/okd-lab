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

resource "openstack_images_image_v2" "fedoracore" {
  name             = "Fedora CoreOS 34.20211016.3.0-openstack"
  image_source_url = "https://repo.hb.bizmrg.com/fedora-coreos-34.20211031.3.0-openstack.x86_64.qcow2"
  container_format = "bare"
  disk_format      = "raw"
}

resource "openstack_compute_keypair_v2" "ssh" {
  name = "terraform_ssh_key"
  public_key = var.SSH_KEY
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

resource "openstack_networking_network_v2" "okd-network" {
  name           = "okd-network"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "okd-subnet" {
  name       = "okd-subnet"
  network_id = "${openstack_networking_network_v2.okd-network.id}"
  cidr       = "192.168.199.0/24"
  ip_version = 4
}

resource "openstack_networking_port_v2" "okd-master-port" {
  name           = "okd-master-port-${count.index}"
  network_id         = "${openstack_networking_network_v2.network_1.id}"
  admin_state_up     = "true"
  security_group_ids = ["${openstack_compute_secgroup_v2.secgroup_1.id}"]

  fixed_ip {
    "subnet_id"  = "${openstack_networking_subnet_v2.subnet_1.id}"
    "ip_address" = [
	"192.168.199.10",
	"192.168.199.11"
	"192.168.199.12"
	"192.168.199.13"
	"192.168.199.14"
	"192.168.199.15"
	]
  }
}