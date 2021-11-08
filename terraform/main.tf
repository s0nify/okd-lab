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
    user_name = "givemeparachute@gmail.com"

    # The password of the account
    password = "YOUR_PASSWORD"

    # The tenant token can be taken from the project Settings tab - > API keys.
    # Project ID will be our token.
    tenant_id = "da50a396acf14358a85377d17e46b613"

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

resource "openstack_networking_network_v2" "network_1" {
  name           = "network_1"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_1" {
  name       = "subnet_1"
  network_id = "${openstack_networking_network_v2.network_1.id}"
  cidr       = "192.168.199.0/24"
  ip_version = 4
}
