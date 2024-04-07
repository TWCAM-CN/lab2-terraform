#!/bin/bash

# Variables específicas de la infraestructura
proyecto=proyecto11
balanceador=proyecto11-balanceador
listener=proyecto11-listener
pool=proyecto11-pool
security_group="tu_grupo_de_seguridad"  # Reemplaza esto con tu grupo de seguridad
monitor="tu_monitor"  # Reemplaza esto con tu monitor

#Obtener el ID del balanceador de carga
loadbalancer_id=$(neutron lbaas-loadbalancer-show $balanceador -c id -f value)

# 1. Obtener el ID del monitor y eliminarlo
echo "Eliminando monitor..."
monitor_id=$(neutron lbaas-healthmonitor-list -c id -f value)
neutron lbaas-healthmonitor-delete $monitor_id

# 2. Eliminar el pool de miembros
echo "Eliminando pool..."
pool_id=$(neutron lbaas-pool-list -c id -f value)
neutron lbaas-pool-delete $pool_id

# 3. Eliminar el listener
echo "Eliminando listener: $listener..."
listener_id=$(neutron lbaas-listener-list -c id -f value)
neutron lbaas-listener-delete $listener_id

# 4. Eliminar el balanceador de carga
echo "Eliminando balanceador de carga: $balanceador..."
neutron lbaas-loadbalancer-delete $balanceador