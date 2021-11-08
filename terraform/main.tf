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

resource "digitalocean_droplet" "web" {
  image  = "ubuntu-18-04-x64"
  name   = "web-1"
  region = "fra1"
  size   = "s-1vcpu-1gb"
  vpc_uuid = "4a6f166a-ebaa-48d9-bd31-29e49c678b71"
}