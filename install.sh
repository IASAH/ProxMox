#!/bin/bash

# Function to check if a command exists
command_exists() {
  command -v "$1" &> /dev/null
}

# Update and upgrade the system
echo "Updating system..."
sudo apt update -y && sudo apt upgrade -y

# Install Python3 and pip if not installed
if ! command_exists python3; then
  echo "Python3 not found. Installing..."
  sudo apt install -y python3
else
  echo "Python3 is already installed."
fi

if ! command_exists pip3; then
  echo "pip3 not found. Installing..."
  sudo apt install -y python3-pip
else
  echo "pip3 is already installed."
fi

# Install Flask if not installed
if ! python3 -c "import flask" &> /dev/null; then
  echo "Flask not found. Installing Flask..."
  sudo pip3 install flask
else
  echo "Flask is already installed."
fi

# Check if the necessary scripts exist and are executable
SCRIPTS=("convert_vdi.sh" "import_disk-new.sh" "import_ovf.sh")

for script in "${SCRIPTS[@]}"; do
  if [ -f "$script" ]; then
    echo "Checking if $script is executable..."
    if [ ! -x "$script" ]; then
      echo "$script is not executable. Making it executable..."
      chmod +x "$script"
    else
      echo "$script is already executable."
    fi
  else
    echo "Script $script not found in the current directory."
  fi
done

# Install other dependencies (e.g., qemu-img)
echo "Installing qemu-img (for VDI conversion)..."
sudo apt install -y qemu-utils

# Additional installations can be added here as required by your app

echo "Installation script completed. All necessary dependencies are installed."
