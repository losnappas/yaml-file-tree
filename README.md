# YAML-file-tree

Build a yaml representation of the current directory. Inpiration from [`ki-editor`](https://ki-editor.github.io/ki-editor/docs/components/file-explorer).

## Usage

```console
$ yaml-file-tree
- 📄 .envrc
- 📄 .gitignore
- 📄 LICENSE.md
- 📄 README.md
- 📄 flake.lock
- 📄 flake.nix
- 📄 pyproject.toml
- 📁 rc/
    - 📄 yaml-file-tree.kak
- 📁 src/
    - 📁 yaml_file_tree/
        - 📄 __init__.py
        - 📄 yaml_file_tree.py
$ yaml-file-tree --open 9 # Builds a filepath from line number.
rc/yaml-file-tree.kak
```

## Installation

Requires [`fd`](https://github.com/sharkdp/fd).

With nix:

```nix
inputs.yaml-file-tree.url = "github:losnappas/yaml-file-tree";
inputs.yaml-file-tree.inputs.nixpkgs.follows = "nixpkgs";
# TODO finish this up
```
