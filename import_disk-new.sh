#!/bin/bash

# Prompt for VM ID or Name
read -p "Enter the VM ID or Name: " VM_NAME

# Prompt for Disk Name
read -p "Enter the disk image name (e.g., disk-image.qcow2): " DISK_NAME

# Specify the storage where the disk will be imported (local storage for example)
STORAGE="local"  # Change this to your storage name if different

# Fetch the actual node name dynamically
NODE_NAME=$(hostname)

# Fetch available storage options from the Proxmox API
storages=$(pvesh get /nodes/$NODE_NAME/storage)

# List available storage options
echo "Available storages:"
echo "$storages"

# Ask user to choose a storage
echo "Please choose the storage (ID):"
read STORAGE_ID

# Run the importdisk command
qm importdisk "$VM_NAME" "$DISK_NAME" "$STORAGE_ID"

# Check if the import was successful
if [ $? -eq 0 ]; then
    echo "Disk $DISK_NAME imported successfully to VM $VM_NAME."
else
    echo "Failed to import disk $DISK_NAME to VM $VM_NAME."
fi
