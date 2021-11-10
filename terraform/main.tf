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

resource "openstack_networking_port_v2" "okd-master-port" {
  count          = var.number_of_masters
  name           = "okd-master-port_${count.index}"
  network_id         = "${openstack_networking_network_v2.network_1.id}"
  admin_state_up = true
  dns_name = "master-${count.index+1}.okd.lab"
  security_group_ids = ["${openstack_compute_secgroup_v2.secgroup_1.id}"]
  
  depends_on = [
    openstack_networking_subnet_v2.subnet_1,
  ]
}

resource "openstack_compute_instance_v2" "master" {
  name            = "master-${count.index+1}"
  count           = var.number_of_masters
  flavor_name     = "Basic-1-1-10"
  key_pair        = openstack_compute_keypair_v2.ssh.name
  config_drive    = true
  image_name      = openstack_images_image_v2.fedoracore.name
  security_groups = ["${openstack_compute_secgroup_v2.secgroup_1.name}"]
  network {
#    port        = "${openstack_networking_port_v2.okd-master-port.*.id[count.index]}"
    name = "${openstack_networking_network_v2.network_1.name}"
	fixed_ip_v4 = "192.168.199.${9+1}"
  }
}

output "path_debug" {
  value = "${var.number_of_workers+var.number_of_masters}"
}