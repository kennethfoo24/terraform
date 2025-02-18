#!/usr/bin/env bash

set -x 
set -e

ZONE=$(terraform output -raw zone)
VM_NAME=$(terraform output -raw vm_name)

# Set your compute zone to match what your terraform is creating
gcloud config set compute/zone "$ZONE"

# Connect via gcloud
echo "Connecting to VM: $VM_NAME in zone: $ZONE"
gcloud compute ssh "$VM_NAME" --zone="$ZONE"

# Moving tf init to here 
terraform init

# Apply the copied .tf file
terraform apply -auto-approve