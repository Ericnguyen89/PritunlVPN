#!/bin/bash

# Function to check if a command is available
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to determine the Linux distribution
get_linux_distribution() {
  if command_exists lsb_release; then
    lsb_release -si
  elif [ -f /etc/os-release ]; then
    source /etc/os-release
    echo "$ID"
  else
    echo "Unknown"
  fi
}

# Get the Linux distribution
linux_distribution=$(get_linux_distribution)

# Check if the Linux distribution is one of the specified ones
if [[ $linux_distribution =~ ^(OracleLinux|AlmaLinux|Rocky|rhel|RedHat)$ ]]; then
  # Install rocky.sh for Oracle Linux, AlmaLinux, Rocky Linux, or RHEL
  echo "Installing rocky.sh..."
  wget https://raw.githubusercontent.com/Ericnguyen89/PriturnVPN/main/server-rocky.sh && sudo bash server-rocky.sh
elif [[ $linux_distribution =~ ^(Ubuntu)$ ]]; then
  # Install ubuntu.sh for Ubuntu
  echo "Installing ubuntu.sh..."
  wget https://raw.githubusercontent.com/Ericnguyen89/PriturnVPN/main/server-ubuntu.sh && sudo bash server-ubuntu.sh
else
  echo "Unsupported Linux distribution: $linux_distribution"
  exit 1
fi

