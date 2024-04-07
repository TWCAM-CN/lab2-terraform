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
floating_ip_id=$(openstack floating ip list | awk '/ $floating_ip_address / {print $2}')

# Crear el balanceador de carga
echo "Creando balanceador de carga: $balanceador..."
neutron lbaas-loadbalancer-create --name $balanceador $subnet
loadbalancer_id=$(neutron lbaas-loadbalancer-show $balanceador | awk '/ id / {print $4}')
echo "Balanceador de carga creado con ID: $loadbalancer_id"

# Esperar hasta que el balanceador esté listo
echo "Esperando a que el balanceador esté listo..."
# Implementa tu lógica de espera aquí
sleep 60
# Crear el listener
echo "Creando listener: $listener..."
neutron lbaas-listener-create --name $listener --loadbalancer $balanceador --protocol HTTP --protocol-port 80

# Crear el pool
echo "Creando pool: $pool..."
neutron lbaas-pool-create --name $pool --lb-algorithm ROUND_ROBIN --listener $listener --protocol HTTP

# Crear los miembros del pool
# Nombres de los servidores
server0=$(terraform output -raw server0_name)
server1=$(terraform output -raw server1_name)
server2=$(terraform output -raw server2_name)
servers=($server0 $server1 $server2)
# Bucle para obtener las direcciones IP de cada servidor
for server in "${servers[@]}"; do
    ip_address=$(openstack server show $server -f value -c addresses)
    ip_address=$(echo $ip_address | cut -d'=' -f2)
    neutron lbaas-member-create --subnet $subnet --address $ip_address --protocol-port 80 $pool
    echo $ip_address
done

# Monitor
neutron lbaas-healthmonitor-create --delay 5 --type HTTP --max-retries 3 --timeout 2 --pool $pool

# Asociar IP flotante al VIP del balanceador de carga
vip_id=$(neutron lbaas-loadbalancer-show $balanceador | awk '/ vip_address / {print $4}')
echo "VIP port ID del balanceador de carga: $vip_port_id"

# Asociar la IP flotante al puerto VIP
echo "Asociando IP flotante $floating_ip_address al balanceador de carga..."
neutron floatingip-associate $floating_ip_id $vip_port_id

# Asociar las reglas de seguridad al balanceador de carga
echo "Asociando reglas de seguridad al balanceador de carga..."
neutron port-update --security-group $securityGroup $vip_port_id

#Fin de la configuración
echo "Configuración del balanceador de carga completada."