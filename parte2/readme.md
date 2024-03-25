# Material práctica 2
## Terraform: IaaC


Este repositorio contiene un proyecto Terraform que usa OpenStack como provider y que contiene un  módulo (`networking`). Este módulo crea una red, una subred y un router.

    ├── cluster.vars
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── providers.tf
    ├── modules
    │   └── networking
    │       ├── main.tf
    │       ├── outputs.tf
    │       ├── variables.tf
    │       └── versions.tf

Partiendo de este proyecto inicial hay que añadir los módulos que se solicitan en el enunciado de la práctica.
