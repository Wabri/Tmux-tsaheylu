#!/usr/bin/env bash

source "$(dirname $0)/helpers.sh"

# move to the current window to do management
cd $(tmux display-message -p -F "#{pane_current_path}")

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    echo 'Usage: ./apply-template.sh workspace_dir worktree_abilitate template_dir
    '
    exit
fi

workspace_dir=$1
worktree_abilitate=$2
template_dir=$3

main() {
    # Project selection
    selected_template=$(select_template "$template_dir")
    [ -z $selected_template ] && exit 1
    absolute_template_path="$template_dir/$selected_template"

    # Apply the template
    if [[ -f ".template.tsaheylu" ]]; then
        while IFS= read -r line; do
            if [[ $selected_template == $line ]]; then
                echo "The template is already applied!"
                exit 1
            fi
        done < ".template.tsaheylu"
    fi
    absolute_template_path="$template_dir/$selected_template"
    apply_template $absolute_template_path
}

main "$@"
