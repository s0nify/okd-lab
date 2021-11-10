# Переменные окружения Terraform Cloud
variable "MCS_PASSWORD" {}
variable "MCS_USERNAME" {}
variable "MCS_PROJECT_ID" {}
variable "SSH_KEY" {}

# Переменные окружения параметров кластера

variable "number_of_masters" {
  default = 4
}

variable "number_of_workers" {
  default = 2
}