terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Необходимо создать проект cloud-okd-lab вручную
data "digitalocean_project" "cloud-okd-lab" {
  name = "cloud-okd-lab"
}

variable "DIGITALOCEAN_TOKEN" {
  type = string
}
# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.DIGITALOCEAN_TOKEN
}

data "digitalocean_ssh_key" "terraform" {
  name = "terraform"
}

# 5 USD, 0.008 + 0.05 + 0.12 + 0.12 + 0.12
resource "digitalocean_droplet" "okd-terminal" {
  image  = "ubuntu-18-04-x64"
  name   = "okd-terminal"
  region = "fra1"
  size   = "s-1vcpu-1gb"
  vpc_uuid = "4a6f166a-ebaa-48d9-bd31-29e49c678b71"
  ssh_keys = [data.digitalocean_ssh_key.terraform.id]
}

# 40 USD, 0.05
resource "digitalocean_droplet" "okd-compute-1" {
  image  = "ubuntu-18-04-x64"
  name   = "okd-compute-1"
  region = "fra1"
  size   = "s-4vcpu-8gb"
  vpc_uuid = "4a6f166a-ebaa-48d9-bd31-29e49c678b71"
  ssh_keys = [data.digitalocean_ssh_key.terraform.id]
}

# 40 USD, 0.05
resource "digitalocean_droplet" "okd-compute-2" {
  image  = "ubuntu-18-04-x64"
  name   = "okd-compute-2"
  region = "fra1"
  size   = "s-4vcpu-8gb"
  vpc_uuid = "4a6f166a-ebaa-48d9-bd31-29e49c678b71"
  ssh_keys = [data.digitalocean_ssh_key.terraform.id]
}

# 80 USD, 0.12
#resource "digitalocean_droplet" "okd-control-plane-1" {
#  image  = "ubuntu-18-04-x64"
#  name   = "okd-control-plane-1"
#  region = "fra1"
#  size   = "s-4vcpu-8gb"
#  vpc_uuid = "4a6f166a-ebaa-48d9-bd31-29e49c678b71"
#  ssh_keys = [data.digitalocean_ssh_key.terraform.id]
#}

# 80 USD, 0.12
#resource "digitalocean_droplet" "okd-control-plane-2" {
#  image  = "ubuntu-18-04-x64"
#  name   = "okd-control-plane-2"
#  region = "fra1"
#  size   = "s-4vcpu-8gb"
#  vpc_uuid = "4a6f166a-ebaa-48d9-bd31-29e49c678b71"
#  ssh_keys = [data.digitalocean_ssh_key.terraform.id]
#}

# 80 USD, 0.12
#resource "digitalocean_droplet" "okd-control-plane-3" {
#  image  = "ubuntu-18-04-x64"
#  name   = "okd-control-plane-3"
#  region = "fra1"
#  size   = "m-2vcpu-16gb"
#  vpc_uuid = "4a6f166a-ebaa-48d9-bd31-29e49c678b71"
#  ssh_keys = [data.digitalocean_ssh_key.terraform.id]
#}

resource "digitalocean_project_resources" "cloud-okd-lab" {
  project = data.digitalocean_project.cloud-okd-lab.id
  resources = [
    digitalocean_droplet.okd-terminal.urn
	digitalocean_droplet.okd-compute-1.urn
	digitalocean_droplet.okd-compute-2.urn
  ]
}