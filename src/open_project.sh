#!/usr/bin/env bash

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    echo 'Usage: ./open_project.sh workspace_dir worktree_abilitate
    '
    exit
fi

main() {
    workspace_dir=$1
    worktree_abilitate=$2
    absolute_projects=`command ls -d $workspace_dir/*/*/*`
    projects="${absolute_projects//$workspace_dir\//}"
    selected_project=`echo $projects | awk -v RS='[ ]' '{print $0}' | fzf`
    absolute_project_path=$workspace_dir/$selected_project

    [[ $worktree_abilitate == "true" ]] && absolute_project_path=$absolute_project_path/wt1

    [ -z "${TMUX}" ] && tmux attach-session -t $selected_project && exit 0

    tmux has-session -t $selected_project >/dev/null

    if [ $? != 0 ]; then
	tmux new-session -d -s $selected_project -c $absolute_project_path
	tmux rename-window -t $selected_project:1 "wt1"
    fi

    tmux switch-client -t $selected_project
}

main "$@"
