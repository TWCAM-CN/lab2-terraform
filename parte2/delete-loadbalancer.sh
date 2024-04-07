#!/bin/bash

# Variables específicas de la infraestructura
proyecto=proyecto11
balanceador=proyecto11-balanceador
listener=proyecto11-listener
pool=proyecto11-pool
security_group="tu_grupo_de_seguridad"  # Reemplaza esto con tu grupo de seguridad
monitor="tu_monitor"  # Reemplaza esto con tu monitor

# 1. Eliminar el monitor
echo "Eliminando monitor: $monitor..."
neutron lbaas-healthmonitor-delete $monitor

# 2. Eliminar el pool de miembros
echo "Eliminando pool: $pool..."
neutron lbaas-pool-delete $pool

# 3. Eliminar el listener
echo "Eliminando listener: $listener..."
neutron lbaas-listener-delete $listener

# 4. Eliminar el balanceador de carga
echo "Eliminando balanceador de carga: $balanceador..."
neutron lbaas-loadbalancer-delete $balanceador