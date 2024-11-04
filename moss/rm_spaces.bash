#!/bin/bash

# Set strict error handling
set -euo pipefail

# Function to print usage
usage() {
    echo "Usage: $0 <directory>"
    echo "Recursively removes spaces from all file and directory names in the specified path"
    exit 1
}

# Function to log operations
log_operation() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Check if directory argument is provided
if [ $# -ne 1 ]; then
    usage
fi

# Check if the provided path exists and is a directory
if [ ! -d "$1" ]; then
    echo "Error: '$1' is not a directory or does not exist"
    exit 1
fi

# Convert to absolute path
target_dir=$(realpath "$1")

# Function to remove spaces from a single path
remove_spaces() {
    local path="$1"
    local dirname=$(dirname "$path")
    local basename=$(basename "$path")
    local newname=$(echo "$basename" | tr ' ' '_')
    
    # Skip if no spaces in name
    if [ "$basename" = "$newname" ]; then
        return
    fi
    
    # Construct new path
    local new_path="${dirname}/${newname}"
    
    # Check if target already exists
    if [ -e "$new_path" ]; then
        log_operation "WARNING: Cannot rename '$path' to '$new_path' - target already exists"
        return
    fi
    
    # Perform the rename
    if mv -n "$path" "$new_path"; then
        log_operation "Renamed: '$path' → '$new_path'"
    else
        log_operation "ERROR: Failed to rename '$path'"
    fi
}

#usage
echo $target_dir

# Main process
log_operation "Starting space removal in: $target_dir"
log_operation "Creating list of paths with spaces..."

# Process directories first (bottom-up to handle nested paths correctly)
while IFS= read -r -d '' dir; do
    remove_spaces "$dir"
done < <(find "$target_dir" -depth -type d -name "* *" -print0)

# Then process files
while IFS= read -r -d '' file; do
    remove_spaces "$file"
done < <(find "$target_dir" -depth -type f -name "* *" -print0)

log_operation "Operation completed"