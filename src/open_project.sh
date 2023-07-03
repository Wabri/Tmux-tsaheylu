#!/usr/bin/env bash

source "$(dirname $0)/helpers.sh"

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    echo 'Usage: ./open_project.sh workspace_dir worktree_abilitate
    '
    exit
fi

main() {
    workspace_dir=$1
    worktree_abilitate=$2
    selected_project=$(select_project "$workspace_dir")
    absolute_project_path=$workspace_dir/$selected_project

    [[ $worktree_abilitate == "true" ]] && absolute_project_path=$absolute_project_path/wt1

    [ -z "${TMUX}" ] && tmux attach-session -t $selected_project && exit 0

    tmux_open_session $selected_project $absolute_project_path
}

main "$@"
