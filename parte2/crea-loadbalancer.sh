#!/bin/bash

# Variables específicas de la infraestructura
proyecto=proyecto11
network=proyecto11-network
subnet=proyecto11-subnetwork
router=proyecto11-router
securityGroup=proyecto11-secgroup
image=8c36a029-c5eb-422a-8b18-92b3052f550e
flavor=10522180-0fa9-4d83-be8b-250330bd4c0a
balanceador=proyecto11-balanceador
listener=proyecto11-listener
pool=proyecto11-pool∫

# Obtener la IP flotante reservada por Terraform
floating_ip_address=$(terraform output -raw floating_ip_address)
floating_ip_id=$(openstack floating ip list | awk '/ 147.156.85.21 / {print $2}')

# Cargar variables de entorno OpenStack
# source ./proyecto11-openrc-ablastu.sh

# Crear el balanceador de carga
echo "Creando balanceador de carga $balanceador..."
neutron lbaas-loadbalancer-create --name proyecto11-balanceador proyecto11-subnetwork
loadbalancer_id=$(neutron lbaas-loadbalancer-show proyecto11-balanceador | awk '/ id / {print $4}')
echo "Balanceador de carga creado con ID: $loadbalancer_id"

# Esperar hasta que el balanceador esté listo
echo "Esperando a que el balanceador esté listo..."
# Implementa tu lógica de espera aquí
sleep 60
# Crear el listener
echo "Creando listener $listener..."
neutron lbaas-listener-create --name proyecto11-listener --loadbalancer proyecto11-balanceador --protocol HTTP --protocol-port 80

# Crear el pool
echo "Creando pool $pool..."
neutron lbaas-pool-create --name proyecto11-pool --lb-algorithm ROUND_ROBIN --listener proyecto11-listener --protocol HTTP

# Crear los miembros del pool
# Nombres de los servidores
servers=("proyecto11_node0" "proyecto11_node1" "proyecto11_node2")
# Bucle para obtener las direcciones IP de cada servidor
for server in "${servers[@]}"; do
    ip_address=$(openstack server show $server -f value -c addresses)
    ip_address=$(echo $ip_address | cut -d'=' -f2)
    neutron lbaas-member-create --subnet proyecto11-subnetwork --address $ip_address --protocol-port 80 proyecto11-pool
    echo $ip_address
done

# Monitor
neutron lbaas-healthmonitor-create --delay 5 --type HTTP --max-retries 3 --timeout 2 --pool proyecto11-pool


# Asociar IP flotante al VIP del balanceador de carga
vip_id=$(neutron lbaas-loadbalancer-show proyecto11-balanceador | awk '/ vip_address / {print $4}')
echo "VIP port ID del balanceador de carga: $vip_port_id"

# Asociar la IP flotante al puerto VIP
echo "Asociando IP flotante $floating_ip_address al balanceador de carga..."
neutron floatingip-associate $floating_ip_id $vip_port_id
echo "Balanceador de carga y configuración completados."

# Asociar las reglas de seguridad al balanceador de carga
neutron port-update --security-group proyecto11-secgroup $vip_port_id
