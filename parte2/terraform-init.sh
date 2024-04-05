#!/bin/bash
terraform init

terraform apply -var-file=cluster.vars -auto-approve
