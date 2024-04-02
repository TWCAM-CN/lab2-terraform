#!/bin/bash

# Variables
loadbalancer_name="proyecto11-balanceador"
floating_ip="<IP flotante asociada al balanceador>"

# Carga las credenciales de OpenStack
source ./proyecto11-openrc-ablastu.sh

# Eliminar el health monitor, los miembros y el pool
echo "Obteniendo ID del pool asociado al balanceador de carga..."
pool_id=$(openstack loadbalancer pool list --loadbalancer $loadbalancer_name -f value -c id)

echo "Eliminando el health monitor del pool..."
hm_id=$(openstack loadbalancer healthmonitor list --pool $pool_id -f value -c id)
openstack loadbalancer healthmonitor delete $hm_id

echo "Eliminando los miembros del pool..."
members=$(openstack loadbalancer member list $pool_id -f value -c id)
for member_id in $members; do
    openstack loadbalancer member delete --pool $pool_id $member_id
done

echo "Eliminando el pool..."
openstack loadbalancer pool delete $pool_id

# Eliminar el listener
echo "Obteniendo ID del listener asociado al balanceador de carga..."
listener_id=$(openstack loadbalancer listener list --loadbalancer $loadbalancer_name -f value -c id)
echo "Eliminando el listener..."
openstack loadbalancer listener delete $listener_id

# Eliminar el balanceador de carga
echo "Eliminando el balanceador de carga..."
openstack loadbalancer delete $loadbalancer_name

# Desasociar la IP flotante del puerto del balanceador de carga
echo "Desasociando la IP flotante del balanceador de carga..."
openstack floating ip set --port None $floating_ip

# Eliminar reglas de seguridad relacionadas si es necesario

echo "Eliminación completada."
