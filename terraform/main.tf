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
  public_key = var.MCS_PASSWORD
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

resource "openstack_blockstorage_volume_v2" "volume" {
  # Название диска
  name = "storage"
  
  # Тип создаваемого диска
  volume_type = "ko1-ssd"
  
  # Размер диска
  size = "50"

  # uuid индикатор образа, в примере используется Ubuntu-18.04-201910
  image_id = "cd733849-4922-4104-a280-9ea2c3145417"
}

resource "openstack_compute_instance_v2" "instance" {
  # Название создаваемой ВМ
  name = "terraform"

  # Имя и uuid образа с ОС
  image_name = "Ubuntu-18.04-201910"
  image_id = "cd733849-4922-4104-a280-9ea2c3145417"
  
  # Конфигурация инстанса
  flavor_name = "Basic-1-1-10"

  # Публичный ключ для доступа
  key_pair = openstack_compute_keypair_v2.ssh.name

  # Указываем, что при создании использовать config drive
  # Без этой опции ВМ не будет создана корректно в сетях без DHCP
  config_drive = true

  # Присваивается security group для ВМ
  security_groups = [
   openstack_compute_secgroup_v2.rules.name
  ]

  # В данном примере используется сеть ext-net
  network {
    name = "ext-net"
  }

  # Блочное устройство
  block_device {
    uuid = openstack_blockstorage_volume_v2.volume.id
    boot_index = 0
    source_type = "volume"
    destination_type = "volume"
    delete_on_termination = true
  }
}
