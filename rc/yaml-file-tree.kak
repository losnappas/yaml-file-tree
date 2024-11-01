provide-module yaml-file-tree %{
    declare-option -docstring "yaml-file-tree executable path" str yaml_file_tree_exec yaml-file-tree

    define-command -override -docstring 'Show file tree' file-tree %{
        fifo -script %{
            $kak_opt_yaml_file_tree_exec
        } -name *file-tree*
        # Hoping to get tree-sitter working for navigating between the files.
        set-option buffer filetype 'yaml'
    }

    define-command -hidden -override file-tree-open-line %{
        evaluate-commands %sh{
            file="$($kak_opt_yaml_file_tree_exec --open "$kak_cursor_line")"
            printf "edit %s\n" "$file"
        }
    }

    hook -group yaml-file-tree global BufCreate ^\*file-tree\*$ %{
        map buffer normal <ret> ': file-tree-open-line<ret>'
    }
}
