#!/bin/bash

# Variables específicas de la infraestructura
proyecto="proyecto11"
balanceador="$proyecto-balanceador"
listener="$proyecto-listener"
pool="$proyecto-pool"
floating_ip_address=$(terraform output -raw floating_ip_address)

# Cargar variables de entorno OpenStack
source ./proyecto11-openrc-ablastu.sh

# Obtener IDs necesarios
loadbalancer_id=$(openstack loadbalancer list -f value -c id --name $balanceador)
vip_port_id=$(openstack loadbalancer show $loadbalancer_id -f value -c vip_port_id)
floating_ip_id=$(openstack floating ip list --floating-ip-address $floating_ip_address -f value -c ID)

# Desasociar IP flotante del puerto VIP
echo "Desasociando IP flotante $floating_ip_address del balanceador de carga..."
openstack floating ip unset --port $vip_port_id $floating_ip_id

# Eliminar el monitor de salud, miembros del pool y el pool
echo "Eliminando el pool $pool y sus componentes..."
pool_id=$(openstack loadbalancer pool list --loadbalancer $loadbalancer_id -f value -c id --name $pool)
members_ids=$(openstack loadbalancer member list $pool_id -f value -c id)
for member_id in $members_ids; do
    echo "Eliminando miembro $member_id del pool $pool..."
    openstack loadbalancer member delete $pool_id $member_id
done
hm_id=$(openstack loadbalancer healthmonitor list --pool $pool_id -f value -c id)
echo "Eliminando monitor de salud $hm_id..."
openstack loadbalancer healthmonitor delete $hm_id
echo "Eliminando pool $pool..."
openstack loadbalancer pool delete $pool_id

# Eliminar el listener
echo "Eliminando listener $listener..."
listener_id=$(openstack loadbalancer listener list --loadbalancer $loadbalancer_id -f value -c id --name $listener)
openstack loadbalancer listener delete $listener_id

# Eliminar el balanceador de carga
echo "Eliminando balanceador de carga $balanceador..."
openstack loadbalancer delete $loadbalancer_id

echo "Infraestructura del balanceador de carga eliminada exitosamente."
