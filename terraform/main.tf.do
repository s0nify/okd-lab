# TODO:
# 1) Вывести тарифы в отдельную переменную для гибкой конфигурации и легкого скейлинга
# 2) Научиться делать вкусный смузи
#
#
#

terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "DIGITALOCEAN_TOKEN" {
  type = string
}

variable "SSH_KEY" {
  type = string
}

provider "digitalocean" {
  token = var.DIGITALOCEAN_TOKEN
}


resource "digitalocean_custom_image" "fedora-coreos" {
  name   = "fedora-coreos"
  url = "https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/34.20211016.3.0/x86_64/fedora-coreos-34.20211016.3.0-digitalocean.x86_64.qcow2.gz"
  regions = ["fra1"]
}


resource "digitalocean_ssh_key" "default" {
  name       = "Terraform key"
  public_key = var.SSH_KEY
}

# 5 USD, 0.008 + 0.05 + 0.12 + 0.12 + 0.12
resource "digitalocean_droplet" "okd-terminal" {
  image  = "digitalocean_custom_image.fedora-coreos.id"
  name   = "okd-terminal"
  region = "fra1"
  size   = "s-1vcpu-1gb"
  vpc_uuid = "4a6f166a-ebaa-48d9-bd31-29e49c678b71"
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
}

# 40 USD, 0.05
resource "digitalocean_droplet" "okd-compute-1" {
  image  = "digitalocean_custom_image.fedora-coreos.id"
  name   = "okd-compute-1"
  region = "fra1"
  size   = "s-4vcpu-8gb"
  vpc_uuid = "4a6f166a-ebaa-48d9-bd31-29e49c678b71"
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
}

# 40 USD, 0.05
resource "digitalocean_droplet" "okd-compute-2" {
  image  = "digitalocean_custom_image.fedora-coreos.id"
  name   = "okd-compute-2"
  region = "fra1"
  size   = "s-4vcpu-8gb"
  vpc_uuid = "4a6f166a-ebaa-48d9-bd31-29e49c678b71"
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
}

# 80 USD, 0.12
#resource "digitalocean_droplet" "okd-control-plane-1" {
#  image  = "digitalocean_custom_image.fedora-coreos.id"
#  name   = "okd-control-plane-1"
#  region = "fra1"
#  size   = "s-4vcpu-8gb"
#  vpc_uuid = "4a6f166a-ebaa-48d9-bd31-29e49c678b71"
#  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
#}

# 80 USD, 0.12
#resource "digitalocean_droplet" "okd-control-plane-2" {
#  image  = "digitalocean_custom_image.fedora-coreos.id"
#  name   = "okd-control-plane-2"
#  region = "fra1"
#  size   = "s-4vcpu-8gb"
#  vpc_uuid = "4a6f166a-ebaa-48d9-bd31-29e49c678b71"
#  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
#}

# 80 USD, 0.12
#resource "digitalocean_droplet" "okd-control-plane-3" {
#  image  = "digitalocean_custom_image.fedora-coreos.id"
#  name   = "okd-control-plane-3"
#  region = "fra1"
#  size   = "m-2vcpu-16gb"
#  vpc_uuid = "4a6f166a-ebaa-48d9-bd31-29e49c678b71"
#  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
#}

resource "digitalocean_project" "cloud-okd-lab" {
  name        = "cloud-okd-lab"
  description = "OKD Cluster Lab"
  purpose     = "OKD"
  environment = "Development"
  resources = [
    digitalocean_droplet.okd-terminal.urn,
	digitalocean_droplet.okd-compute-1.urn,
	digitalocean_droplet.okd-compute-2.urn
  ]
}