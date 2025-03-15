#!/bin/bash

# Find the chrome-sandbox binary in the user's home directory
sandbox_path=$(find ~ -type f -name "chrome-sandbox" 2>/dev/null)

# Check if the file was found
if [ -z "$sandbox_path" ]; then
    echo "chrome-sandbox not found. Ensure Burp Suite is installed."
    exit 1
fi

# Change ownership and permissions
echo "Setting root ownership and SUID permissions for: $sandbox_path"
sudo chown root:root "$sandbox_path" && sudo chmod 4755 "$sandbox_path"

# Verify the changes
echo "Updated permissions:"
ls -l "$sandbox_path"
