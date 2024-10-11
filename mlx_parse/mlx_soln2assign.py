#!/usr/bin/env python3

import zipfile
import tempfile
import os
#import shutil
#import xml.etree.ElementTree as ET
import re 
import argparse

def process_mlx_file(input_filename, output_filename):
    # Step 1: Expand the zip archive into a temporary directory
    with tempfile.TemporaryDirectory() as temp_dir:
        with zipfile.ZipFile(input_filename, 'r') as zip_ref:
            zip_ref.extractall(temp_dir)
        
        # Step 2: Read and modify the XML file
        # Read the content of the XML file
        xml_file_path = os.path.join(temp_dir, "matlab", "document.xml")
        with open(xml_file_path, 'r', encoding='utf-8') as file:
            content = file.read()

        # Find all CDATA sections and replace their content
        # Define the regex pattern for CDATA sections
        cdata_pattern = r'<!\[CDATA\[(.*?)\]\]>'
        # Replace CDATA content with the placeholder
        modified_content = re.sub(cdata_pattern, '<![CDATA[% Your code here]]>', content, flags=re.DOTALL)
        
        # Step 3: Save the modified XML file
        # Write the modified content back to a new the file
        with open(xml_file_path, 'w', encoding='utf-8') as file:
            file.write(modified_content)

        # Step 4: Recompress all files into a new zip archive
        with zipfile.ZipFile(output_filename, 'w', zipfile.ZIP_DEFLATED) as zipf:
            for root, _, files in os.walk(temp_dir):
                for file in files:
                    file_path = os.path.join(root, file)
                    arcname = os.path.relpath(file_path, temp_dir)
                    zipf.write(file_path, arcname)

def modify_filename(file_name):
    """
    Modify the base name of a given file by removing '_soln' or appending '_nocode'.

    This function checks the base name of the input file (excluding the extension).
    - If the base name contains '_soln', it removes this substring.
    - If '_soln' is not found, it appends '_nocode' to the base name.
    The file extension remains unchanged.

    Args:
        file_name (str): The name of the file to be modified, including its extension.

    Returns:
        str: The modified file name with the appropriate changes to the base name.
    """
    # Separate the base name and extension
    base_name, ext = os.path.splitext(file_name)
    
    if '_soln' in base_name:
        # Remove '_soln' from the base name
        new_base_name = base_name.replace('_soln', '')
    else:
        # Append '_nocode' to the base name if '_soln' is not found
        new_base_name = base_name + '_nocode'
    
    # Combine the modified base name with the original extension
    new_file_name = new_base_name + ext
    return new_file_name


def main():
    parser = argparse.ArgumentParser(
        prog = 'mlx_soln2assign.py',
        description="Process an MLX file to replace CDATA content in the matlab/document.xml file.",
        epilog="""
Examples:
  1. Process an MLX file with default output naming.:
   input.mlx

  2. Process an MLX file with a specified output name:
     input.mlx -o output.mlx

Description:
  This script performs the following operations:
  1. Expands the input MLX file (which is a ZIP archive) into a temporary directory.
  2. Reads the 'matlab/document.xml' file within the expanded contents.
  3. Replaces all text within CDATA sections with 'CDATA[% Your code here]'.
  4. Saves the modified XML file.
  5. Recompresses all files in the temporary directory into a new MLX file.

  If no output file is specified, the script will create a new file with '_assign' 
  appended to the original filename (before the extension).
        """,
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument("input_file", help="Path to the input MLX file")
    parser.add_argument("-o", "--output_file", help="Path to the output MLX file (optional)")
    args = parser.parse_args()

    input_file = args.input_file
    if args.output_file:
        output_file = args.output_file
    else:
        output_file = modify_filename(input_file)

    process_mlx_file(input_file, output_file)
    print(f"Processed {input_file} and created {output_file}")

if __name__ == "__main__":
    main()

