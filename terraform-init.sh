#!/bin/bash
terraform init
sleep 2
terraform apply -var-file=cluster.vars -auto-approve
