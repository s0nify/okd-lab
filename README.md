![okd-cloud-lab](/project.jpg)

# Что это?

Лабораторный проект по мотивам [статьи от Craig Robinson](https://itnext.io/guide-installing-an-okd-4-5-cluster-508a2631cbee), для развертывания инфраструктуры OKD (OpenShift) в облаке DigitalOcean.

Развертывание ландшафта происходит с помощью [Terraform Cloud](https://www.terraform.io/cloud), каталог terraform.


## Что необходимо для старта?

DigitalOcean:
1. Создать проект, использовать имя cloud-okd-lab
2. Добавить публичный ключ с названием terraform
3. Получить и сохранить токен для доступа к API

Terraform Cloud:
1. Создать проект, указать репозиторий на Github и указать переменную окружения Terraform для `DIGITALOCEAN_TOKEN`