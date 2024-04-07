#!/bin/bash

# Nombres de los servidores
servers=("proyecto11_node0" "proyecto11_node1" "proyecto11_node2")

# Bucle para obtener las direcciones IP de cada servidor
for server in "${servers[@]}"; do
    ip_address=$(openstack server show $server -f value -c addresses)
    ip_address=$(echo $ip_address | cut -d'=' -f2)
    neutron lbaas-member-create --subnet proyecto11-subnetwork --address $ip_address --protocol-port 80 proyecto11-pool
    echo $ip_address
done