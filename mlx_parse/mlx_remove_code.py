import re

def replace_cdata(file_path, newfile_path):
    # Read the content of the XML file
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()

    # Define the regex pattern for CDATA sections
    cdata_pattern = r'<!\[CDATA\[(.*?)\]\]>'

    # Replace CDATA content with the placeholder
    modified_content = re.sub(cdata_pattern, '<![CDATA[% Your code here]]>', content, flags=re.DOTALL)

    # Write the modified content back to a new the file
    with open(newfile_path, 'w', encoding='utf-8') as file:
        file.write(modified_content)

    print(f"CDATA sections in {file_path} have been replaced and new file {newfile_path} written.")

# Use the function
file_path = 'tmp/matlab/document.xml'
newfile_path = 'tmp/matlab/newdocument.xml'
replace_cdata(file_path, newfile_path)