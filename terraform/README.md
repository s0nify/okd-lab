# Что это?

Комплект скриптов необходимый для развертывания инфраструктуры OKD в Digital Ocean

## What will this do?

This is a Terraform configuration that will create an EC2 instance in your AWS account. 

When you set up a Workspace on Terraform Cloud, you can link to this repository. Terraform Cloud can then run `terraform plan` and `terraform apply` automatically when changes are pushed. For more information on how Terraform Cloud interacts with Version Control Systems, see [our VCS documentation](https://www.terraform.io/docs/cloud/run/ui.html).

## What are the prerequisites?

Со стороны DO необходимо добавить публичный ключ с названием terraform.

Необходимо указать переменные окружения `DIGITALOCEAN_TOKEN`, `DIGITALOCEAN_ACCESS_TOKEN`
