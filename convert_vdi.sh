#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0"
    echo "This script converts a VDI file to VMDK or RAW format."
    exit 1
}

# Prompt for input VDI file
read -p "Enter the path to the input VDI file: " INPUT

# Check if the input file exists
if [ ! -f "$INPUT" ]; then
    echo "Input file does not exist."
    exit 1
fi

# Prompt for output file name (without extension)
read -p "Enter the desired output file name (without extension): " OUTPUT_NAME

# Prompt for output format
read -p "Enter the output format (vmdk or raw): " FORMAT

# Determine output file extension
case "$FORMAT" in
    vmdk)
        OUTPUT_EXT=".vmdk"
        ;;
    raw)
        OUTPUT_EXT=".img"
        ;;
    *)
        echo "Invalid format specified. Please enter 'vmdk' or 'raw'."
        exit 1
        ;;
esac

# Construct the output file path
OUTPUT="${OUTPUT_NAME}${OUTPUT_EXT}"

# Convert the VDI file
echo "Converting $INPUT to $OUTPUT format..."

if ! qemu-img convert -f vdi -O "$FORMAT" "$INPUT" "$OUTPUT"; then
    echo "Conversion failed."
    exit 1
fi

echo "Conversion successful: $INPUT -> $OUTPUT"
