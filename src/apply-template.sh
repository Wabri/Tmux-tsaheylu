#!/usr/bin/env bash

source "$(dirname $0)/helpers.sh"

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    echo 'Usage: ./cloning_project.sh workspace_dir worktree_abilitate
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
    apply_template $absolute_template_path

    # Save the applied template
    echo $selected_template >> .template.tsaheylu
}

main "$@"
