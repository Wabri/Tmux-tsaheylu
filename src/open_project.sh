#!/usr/bin/env bash

source "$(dirname $0)/helpers.sh"

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    echo 'Usage: ./open_project.sh workspace_dir worktree_abilitate
    '
    exit
fi

workspace_dir=$1
worktree_abilitate=$2

main() {
    # Project selection
    selected_project=$(select_project "$workspace_dir")
    [ -z $selected_project ] && exit 1

    # Open project
    absolute_project_path=$workspace_dir/$selected_project
    if [[ ! $absolute_project_path =~ ^.*/[^/]*:[^/]*(/.*)?$ ]] && ls $absolute_project_path | grep -q "^wt1$"; then
        absolute_project_path=$absolute_project_path/wt1
    fi
    if [[ $absolute_project_path =~ ^.*/[^/]*:[^/]*(/.*)?$ ]]; then
        selected_project=$(echo $selected_project | sed "s/:/_/g")
    fi
    [ -z "${TMUX}" ] && tmux attach-session -t $selected_project && exit 0
    tmux_open_session $selected_project $absolute_project_path
}

main "$@"
