import subprocess
import itertools

# Function to recursively build the tree
def group_sorted_files_by_directory(paths):
    # Group by the first part of the path
    grouped = itertools.groupby(paths, key=lambda x: x.split('/')[0])

    tree = []
    for key, group in grouped:
        # A bug causes an empty item to appear as 1st item in any dir.
        if key == "":
            continue
        group = list(group)
        if len(group) == 1 and '/' not in group[0]:  # Leaf node
            tree.append(key)
        else:
            # Recursively process the rest of the path
            sub_paths = [p[len(key)+1:] for p in group if '/' in p]
            tree.insert(0, [key, group_sorted_files_by_directory(sub_paths)])

    return tree

def map_contents(root_dir, additional_ignores=None):
    # Base command for fd
    command = ['fd', '--hidden', '--exclude', '.git']

    # Add additional ignores
    if additional_ignores:
        for ignore in additional_ignores:
            command.extend(['--exclude', ignore])

    # Add the root directory to search
    command.append(root_dir)

    # Run the command and capture the output
    result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

    # Check for errors
    if result.returncode != 0:
        raise RuntimeError(f"fd command failed: {result.stderr}")

    # Return the list of files found
    return result.stdout.splitlines()


type_icon_map = {"folder": "📁", "file": "📄"}

def build_tree(tree, indent=0, indent_per_level=4):
    tree_str = ""
    # Tabs are not valid indent in yaml, unfortunately.
    spaces = " " * indent_per_level
    for part in tree:
        tree_str += spaces
        if isinstance(part, str):
            tree_str += f"- {type_icon_map['file']} {part}\n"
        else:
            part, subtree = part
            tree_str += f"- {type_icon_map['folder']} {part}/\n"
            tree_str += build_tree(subtree, indent + 1, indent_per_level)
    return tree_str

def print_file_tree(path = "."):
    repo = map_contents(path, additional_ignores=['.jj', '.hg'])

    nested_tree = group_sorted_files_by_directory(repo)

    print(build_tree(nested_tree))

if __name__ == '__main__':
    print_file_tree()
