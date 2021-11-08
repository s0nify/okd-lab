![okd-cloud-lab](/project.jpg)

# Что это?

Лабораторный проект по мотивам [статьи от Craig Robinson](https://itnext.io/guide-installing-an-okd-4-5-cluster-508a2631cbee), для развертывания инфраструктуры OKD (OpenShift) в облаке DigitalOcean.

Развертывание ландшафта происходит с помощью [Terraform Cloud](https://www.terraform.io/cloud), каталог terraform.


## Что необходимо для старта?

Со стороны DO необходимо добавить публичный ключ с названием terraform, создать проект cloud-okd-lab.

Необходимо указать переменные окружения `DIGITALOCEAN_TOKEN`
