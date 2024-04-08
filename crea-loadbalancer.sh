#!/bin/bash

# Variables específicas de la infraestructura
proyecto=proyecto11
balanceador=proyecto11-balanceador
listener=proyecto11-listener
pool=proyecto11-pool
network=proyecto11-network
subnet=proyecto11-subnetwork
router=proyecto11-router
securityGroup=proyecto11-secgroup
image=8c36a029-c5eb-422a-8b18-92b3052f550e
flavor=10522180-0fa9-4d83-be8b-250330bd4c0a

# Obtener la IP flotante reservada por Terraform
floating_ip_address=$(terraform output -raw floating_ip_address)
floating_ip_id=$(openstack floating ip list -f value -c ID)

# Crear el balanceador de carga
echo "Creando balanceador de carga: $balanceador..."
neutron lbaas-loadbalancer-create --name $balanceador $subnet
sleep 5
echo ""

# Espera hasta que el balanceador de carga esté en estado ACTIVE
echo "Esperando a que el balanceador de carga esté listo..."
while true; do
    provisioning_status=$(neutron lbaas-loadbalancer-show $balanceador -f value -c provisioning_status)
    if [ "$provisioning_status" == "ACTIVE" ]; then
        echo "Balanceador de carga está activo."
        break
    elif [ "$provisioning_status" == "ERROR" ]; then
        echo "Error en la creación del balanceador de carga."
        exit 1
    else
        echo "Esperando... (estado actual: $provisioning_status)"
        sleep 10
    fi
done

# Obtener el ID del balanceador de carga
echo "Obteniendo el ID del balanceador de carga..."
loadbalancer_id=$(neutron lbaas-loadbalancer-show $balanceador | awk '/ id / {print $4}')
sleep 5
echo "Balanceador de carga creado con ID: $loadbalancer_id"
echo ""

# Crear el listener
echo "Creando listener: $listener..."
neutron lbaas-listener-create --name $listener --loadbalancer $balanceador --protocol HTTP --protocol-port 80
sleep 5
echo "Listener creado."
echo ""

# Espera de nuevo hasta que el balanceador de carga esté en estado ACTIVE después de crear el listener
echo "Esperando a que el balanceador de carga se actualice después de crear el listener..."
while true; do
    provisioning_status=$(neutron lbaas-loadbalancer-show $balanceador -f value -c provisioning_status)
    if [ "$provisioning_status" == "ACTIVE" ]; then
        echo "Balanceador de carga listo para la creación del pool."
        break
    elif [ "$provisioning_status" == "ERROR" ]; then
        echo "Error después de la creación del listener."
        exit 1
    else
        echo "Esperando... (estado actual: $provisioning_status)"
        sleep 10
    fi
done

# Crear el pool
echo "Creando pool: $pool..."
neutron lbaas-pool-create --name proyecto11-pool --lb-algorithm ROUND_ROBIN --listener proyecto11-listener --protocol HTTP
sleep 5
echo "Pool creado."
echo ""

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
    sleep 5
    echo $ip_address
    echo ""
done


# Monitor
echo "Creando monitor..."
neutron lbaas-healthmonitor-create --delay 5 --type HTTP --max-retries 3 --timeout 2 --pool $pool
echo ""

# Asociar IP flotante al VIP del balanceador de carga
echo "Obteniendo el puerto VIP del balanceador de carga..."
vip_port_id=$(neutron lbaas-loadbalancer-show $balanceador | awk '/ vip_port_id / {print $4}')
echo "VIP port ID del balanceador de carga: $vip_port_id"
echo ""

# Asociar la IP flotante al puerto VIP
echo "Asociando IP flotante $floating_ip_address al balanceador de carga..."
neutron floatingip-associate $floating_ip_id $vip_port_id
echo ""

# Asociar las reglas de seguridad al balanceador de carga
echo "Asociando reglas de seguridad al balanceador de carga..."
neutron port-update --security-group $securityGroup $vip_port_id
echo ""

#Fin de la configuración
echo "Configuración del balanceador de carga completada."
echo ""