#!/bin/bash

# Define the directories to search
directory1="/etc/pve/lxc/" # Replace with the first directory path
directory2="/etc/pve/qemu-server/" # Replace with the second directory path

# Initialize a variable to store all the filenames
file_list=""

# Function to process .conf files in a directory
process_directory() {
  local dir="$1"
  for file in "$dir"/*.conf; do
    # Check if the file exists to avoid errors
    if [[ -f "$file" ]]; then
      # Remove the .conf extension and add it to the file list
      filename=$(basename "$file" .conf)
      file_list+="$filename "
    fi
  done
}

# Process both directories
process_directory "$directory1"
process_directory "$directory2"

# Display the list of available files
echo "Files found: $file_list"

# Loop to prompt the user until they provide a unique name
while true; do
  # Prompt the user to enter a file name
  read -p "Please specify a VMID: " user_input

  # Check if the entered name exists in the directory
  if echo "$file_list" | grep -qw "$user_input"; then
    echo "VMID '$user_input' already in use"
  else
    echo "VMID '$user_input' ok"
    break
  fi
done
