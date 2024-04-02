#!/bin/bash

# Variables de entorno específicas de tu configuración
nombre_subred_selfservice="proyecto11-subnetwork"
nombre_balanceador="proyecto11-balanceador"
nombre_listener="proyecto11-listener"
nombre_pool="proyecto11-pool"
nombre_healthmonitor="proyecto11-healthmonitor"
grupo_seguridad="proyecto11-secgroup"
pool="external-network"

# Activar el entorno de OpenStack (asegúrate de que este comando funcione para tu configuración)
source ./proyecto11-openrc-ablastu.sh

# Obtener ID de la subred
subred_id=$(openstack subnet show $nombre_subred_selfservice -f value -c id)

# Crear el balanceador de carga
neutron lbaas-loadbalancer-create --name $nombre_balanceador $subred_id

# Esperar hasta que el balanceador esté activo
echo "Esperando que el balanceador esté activo..."
sleep 60

# Crear el listener
neutron lbaas-listener-create --name $nombre_listener --loadbalancer $nombre_balanceador --protocol HTTP --protocol-port 80

# Crear el pool
neutron lbaas-pool-create --name $nombre_pool --lb-algorithm ROUND_ROBIN --listener $nombre_listener --protocol HTTP

# Obtener IPs de las instancias
instancia_ips=$(openstack server list --name "proyecto11_node" -f value -c Networks | awk -F'=' '{print $2}')

# Añadir miembros al pool
for ip in $instancia_ips; do
  neutron lbaas-member-create --subnet $subred_id --address $ip --protocol-port 80 $nombre_pool
done

# Crear el monitor de salud
neutron lbaas-healthmonitor-create --delay 5 --type HTTP --max-retries 3 --timeout 2 --pool $nombre_pool

# Asociar IP flotante al balanceador de carga
id_floating_ip=$(openstack floating ip create $pool -f value -c id)
id_port=$(neutron lbaas-loadbalancer-show $nombre_balanceador -f value -c vip_port_id)
neutron floatingip-associate $id_floating_ip $id_port

# Actualizar reglas de seguridad
id_grupo_seguridad=$(openstack security group list --name $grupo_seguridad -f value -c ID)
openstack security group rule create --protocol tcp --dst-port 80:80 $id_grupo_seguridad
openstack security group rule create --protocol icmp $id_grupo_seguridad

echo "Balanceador de carga y configuración completados."
