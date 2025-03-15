#!/bin/bash

# Directories to search
dir1="/etc/pve/lxc"
dir2="/etc/pve/qemu-server"

# Array to hold .conf file names (without extension)
files=()

echo

# Find .conf files in the first directory
if [ -d "$dir1" ]; then
    for file in "$dir1"/*.conf; do
        if [ -e "$file" ]; then
            filename=$(basename "$file" .conf)
            files+=("$filename")
            echo "$(( ${#files[@]} )). $filename"
        fi
    done
else
    echo "No directory found!"
fi

# Find .conf files in the second directory
if [ -d "$dir2" ]; then
    for file in "$dir2"/*.conf; do
        if [ -e "$file" ]; then
            filename=$(basename "$file" .conf)
            files+=("$filename")
            echo "$(( ${#files[@]} )). $filename"
        fi
    done
else
    echo "No directory found!"
fi

# Check if any .conf files were found
if [ "${#files[@]}" -eq 0 ]; then
    echo "No VMs found"
    exit 1
fi

# Prompt user to select a file
while true; do
    echo
    read -p "Please select a VM from the list to reboot: " selection

    # Validate user input
    if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le "${#files[@]}" ]; then
        selected_file="${files[$((selection-1))]}"
        echo "VM $selected_file will be rebooted"
        # Run the command `qm start 'file name'`
        qm reboot "$selected_file"
        break
    else
        echo "VM does not exist"
    fi
done
