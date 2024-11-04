#!/bin/bash

# Set strict error handling
set -euo pipefail

# Function to print usage
usage() {
    echo "Usage: $0 <directory>"
    echo "Recursively removes spaces and parentheses from all file and directory names in the specified path"
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

# Function to clean filename
clean_filename() {
    echo "$1" | tr ' ()' '_'
}

# Function to remove spaces and parentheses from a single path
clean_path() {
    local path="$1"
    local dirname=$(dirname "$path")
    local basename=$(basename "$path")
    local newname=$(clean_filename "$basename")
    
    # Skip if no changes needed
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

# Main process
log_operation "Starting cleanup in: $target_dir"
log_operation "Creating list of paths with spaces or parentheses..."

# Process directories first (bottom-up to handle nested paths correctly)
while IFS= read -r -d '' dir; do
    clean_path "$dir"
done < <(find "$target_dir" -depth -type d -regextype posix-extended -regex '.*/[^/]*[ ()].*' -print0)

# Then process files
while IFS= read -r -d '' file; do
    clean_path "$file"
done < <(find "$target_dir" -depth -type f -regextype posix-extended -regex '.*/[^/]*[ ()].*' -print0)

log_operation "Operation completed"

# Print summary of remaining problematic files (if any)
echo -e "\nChecking for any remaining files with spaces or parentheses..."
if find "$target_dir" -regextype posix-extended -regex '.*/[^/]*[ ()].*' -print0 | grep -q .; then
    echo "Warning: Some files could not be processed:"
    find "$target_dir" -regextype posix-extended -regex '.*/[^/]*[ ()].*' -print
else
    echo "All files processed successfully!"
fi