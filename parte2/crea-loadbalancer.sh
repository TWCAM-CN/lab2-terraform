#!/bin/bash

# Variables específicas de la infraestructura
proyecto="proyecto11"
network="$proyecto-network"
subnet="$proyecto-subnetwork"
router="$proyecto-router"
securityGroup="$proyecto-secgroup"
image="8c36a029-c5eb-422a-8b18-92b3052f550e" # ID de imagen Ubuntu focal
flavor="10522180-0fa9-4d83-be8b-250330bd4c0a" # ID de flavor para los servidores
balanceador="$proyecto-balanceador"
listener="$proyecto-listener"
pool="$proyecto-pool"

# Obtener la IP flotante reservada por Terraform
floating_ip_address=$(terraform output -raw floating_ip_address)

# Cargar variables de entorno OpenStack
source ./proyecto11-openrc-ablastu.sh

# Crear el balanceador de carga
echo "Creando balanceador de carga $balanceador..."
loadbalancer_id=$(openstack loadbalancer create --name $balanceador --vip-subnet-id $subnet -f value -c id)
echo "Balanceador de carga creado con ID: $loadbalancer_id"

# Esperar hasta que el balanceador esté listo
echo "Esperando a que el balanceador esté listo..."
# Implementa tu lógica de espera aquí
sleep 60
# Crear el listener
echo "Creando listener $listener..."
openstack loadbalancer listener create --name $listener --protocol HTTP --protocol-port 80 --loadbalancer $loadbalancer_id

# Crear el pool
echo "Creando pool $pool..."
openstack loadbalancer pool create --name $pool --lb-algorithm ROUND_ROBIN --listener $listener --protocol HTTP

# Asociar IP flotante al VIP del balanceador de carga
vip_port_id=$(openstack loadbalancer show $loadbalancer_id -f value -c vip_port_id)
echo "VIP port ID del balanceador de carga: $vip_port_id"

# Asociar la IP flotante al puerto VIP
echo "Asociando IP flotante $floating_ip_address al balanceador de carga..."
floating_ip_id=$(openstack floating ip list --floating-ip-address $floating_ip_address -f value -c ID)
openstack floating ip set --port $vip_port_id $floating_ip_id

echo "Balanceador de carga y configuración completados."



