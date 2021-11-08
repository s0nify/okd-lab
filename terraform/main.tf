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

resource "digitalocean_droplet" "okd-terminal" {
  image  = "ubuntu-18-04-x64"
  name   = "okd-terminal"
  region = "fra1"
  size   = "s-1vcpu-1gb"
  vpc_uuid = "4a6f166a-ebaa-48d9-bd31-29e49c678b71"
}

#resource "digitalocean_droplet" "okd-services" {
#  image  = "ubuntu-18-04-x64"
#  name   = "okd-services"
#  region = "fra1"
#  size   = "s-1vcpu-1gb"
#  vpc_uuid = "4a6f166a-ebaa-48d9-bd31-29e49c678b71"
#}

resource "digitalocean_project_resources" "cloud-okd-lab" {
  project = data.digitalocean_project.cloud-okd-lab.id
  resources = [
    digitalocean_droplet.web.urn
  ]
}