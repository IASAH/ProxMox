#!/bin/bash

# Prompt for VM ID
read -p "Enter the VM ID: " VM_ID

# Prompt for OVF file path
read -p "Enter the path to the OVF file (e.g., /path/to/your-file.ovf): " OVF_PATH

# Prompt for VM Name
read -p "Enter the VM name: " VM_NAME

# Specify the storage where the disk will be imported
read -p "Enter the storage name (e.g., local): " STORAGE

# Specify network options
read -p "Enter the network bridge (e.g., vmbr0): " NETWORK_BRIDGE

# Optional: Specify other settings as needed
read -p "Enter the CPU cores (default 1): " CPU_CORES
CPU_CORES=${CPU_CORES:-1}  # Default to 1 if no input

read -p "Enter the memory size in MB (default 1024): " MEMORY
MEMORY=${MEMORY:-1024}  # Default to 1024 MB if no input

# Run qm importovf command
qm importovf "$VM_ID" "$OVF_PATH" "$STORAGE" --name "$VM_NAME" --cores "$CPU_CORES" --memory "$MEMORY" --net0 "virtio,bridge=$NETWORK_BRIDGE"

# Check if the import was successful
if [ $? -eq 0 ]; then
    echo "OVF $OVF_PATH imported successfully as VM $VM_NAME with ID $VM_ID."
else
    echo "Failed to import OVF $OVF_PATH."
fi
