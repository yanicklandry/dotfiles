#!/bin/bash

# Get current timestamp in a readable format
# Format: YYYY-MM-DD_HH-MM-SS
timestamp=$(date "+%Y-%m-%d_%H-%M-%S")

# Create the folder name
folder_name="${timestamp}"

# Create the directory
mkdir -p "$folder_name"

# Print the created folder name
echo "Created folder: $folder_name"

# Optional: Print the absolute path
echo "Absolute path: $(pwd)/$folder_name"