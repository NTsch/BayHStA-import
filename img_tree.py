import os
import xml.etree.ElementTree as ET

def create_jpg_xml_tree(root_dir):
    """
    Create an XML tree representing the locations of all .jpg files in a directory and its subdirectories.
    
    :param root_dir: The root directory to start the search.
    :return: An ElementTree object representing the XML structure.
    """
    # Create the root XML element
    root = ET.Element("Files")

    # Walk through the directory and subdirectories
    for dirpath, _, filenames in os.walk(root_dir):
        # Filter for .jpg files
        jpg_files = [f for f in filenames if f.lower().endswith('.jpg')]
        
        if jpg_files:
            # Create an XML element for the current directory
            dir_element = ET.SubElement(root, "Directory", path=os.path.relpath(dirpath, root_dir))
            
            for jpg_file in jpg_files:
                # Add each JPG file as a child element
                ET.SubElement(dir_element, "File", name=jpg_file)

    return ET.ElementTree(root)

# Define the directory to search
current_dir = os.getcwd()

# Create the XML tree
xml_tree = create_jpg_xml_tree(current_dir)

# Save the XML tree to a file
output_file = "jpg_files.xml"
xml_tree.write(output_file, encoding="utf-8", xml_declaration=True)

print(f"XML tree saved to {output_file}")
