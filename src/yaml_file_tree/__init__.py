from .yaml_file_tree import print_file_tree, print_file_name
from argparse import ArgumentParser

def main():
    parser = ArgumentParser(
        description="YAML file tree"
    )
    parser.add_argument(
        '--open',
        type=int,
        nargs='?',
        const=None,
        default=None,
        help="Construct a full filepath for file at line number."
    )
    args = parser.parse_args()
    if args.open:
        print_file_name(args.open)
    else:
        print_file_tree()
