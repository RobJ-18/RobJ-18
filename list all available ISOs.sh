#!/bin/bash

# Specify the directory to search (e.g., your storage drive path)
STORAGE_DRIVE="/mnt/pve/ISO_store/template/iso"

# Check if the specified directory exists
if [ -d "$STORAGE_DRIVE" ]; then
    # Find all .iso files and store them in an array
    mapfile -t iso_files < <(find "$STORAGE_DRIVE" -type f -name "*.iso" -exec basename {} \; | sort)

    # Check if any .iso files were found
    if [ ${#iso_files[@]} -eq 0 ]; then
        echo "No .iso files found in the specified directory."
        exit 1
    fi

    # Display the numbered list of .iso files
#    echo "Please select an ISO:"
    for i in "${!iso_files[@]}"; do
        echo "$((i + 1)). ${iso_files[i]}"
    done

    # Prompt the user to select an item
    while true; do
        read -p "Please select an ISO: " choice

        # Validate the user's input
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#iso_files[@]}" ]; then
            echo "${iso_files[$((choice - 1))]} selected"
            break
        else
            echo "Invalid choice. Please enter a number between 1 and ${#iso_files[@]}."
        fi
    done
else
    echo "Error: The specified path does not exist or is not a directory."
    exit 1
fi
