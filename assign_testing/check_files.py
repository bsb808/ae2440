#!/usr/bin/env python3
import os

def check_files_in_submission_folders(base_path, filenames):
    # Store results
    passing_folders = []
    failing_folders = []

    # Iterate through the direct subfolders of the base directory
    for subfolder in os.listdir(base_path):
        subfolder_path = os.path.join(base_path, subfolder)

        # Skip if it's not a directory
        if not os.path.isdir(subfolder_path):
            continue

        # Define the path to the "Submission attachment(s)" subfolder
        submission_path = os.path.join(subfolder_path, "Submission attachment(s)")

        # Check if "Submission attachment(s)" exists
        if os.path.exists(submission_path) and os.path.isdir(submission_path):
            # Get the list of files in the "Submission attachment(s)" subfolder
            files = os.listdir(submission_path)

            # Check for missing files
            missing_files = [f for f in filenames if f not in files]

            if not missing_files:
                # All files exist
                passing_folders.append(submission_path)
            else:
                # Some files are missing, store folder, missing files, and its contents
                failing_folders.append({
                    'folder': submission_path,
                    'missing_files': missing_files,
                    'folder_contents': files
                })
        else:
            # "Submission attachment(s)" folder does not exist
            failing_folders.append({
                'folder': subfolder_path,
                'missing_files': filenames,  # All files are considered missing
                'folder_contents': 'Folder "Submission attachment(s)" does not exist'
            })

    # Report results
    print("Subfolders that pass the test (all files exist in 'Submission attachment(s)'):")
    for folder in passing_folders:
        print(f"- {folder}")

    print("\nSubfolders that fail the test (missing files or missing 'Submission attachment(s)' folder):")
    for fail in failing_folders:
        print(f"- {fail['folder']}")
        print(f"  Missing files: {fail['missing_files']}")
        print(f"  Folder contents: {fail['folder_contents']}\n")


# Example usage:
base_path = "/home/bsb/Classes/AE2440/StudentWork/AY25Q1/Assignment 1_ Models and Scripts /"
filenames = ["penny.m", "pennywithair.mlx", "bike_share.m", "aquarium.mlx"]  # List of filenames to check
check_files_in_submission_folders(base_path, filenames)
