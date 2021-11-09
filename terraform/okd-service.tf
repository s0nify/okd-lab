resource "openstack_networking_port_v2" "port_1" {
  name               = "port_1"
  network_id         = "${openstack_networking_network_v2.network_1.id}"
  admin_state_up     = "true"
  security_group_ids = ["${openstack_compute_secgroup_v2.secgroup_1.id}"]

  fixed_ip {
    subnet_id  = "${openstack_networking_subnet_v2.subnet_1.id}"
    ip_address = "192.168.199.10"
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

  security_groups = ["${openstack_compute_secgroup_v2.secgroup_1.name}"]

  network {
    port = "${openstack_networking_port_v2.port_1.id}"
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