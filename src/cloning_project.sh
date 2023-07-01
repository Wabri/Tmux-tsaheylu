#!/usr/bin/env bash

source "$(dirname $0)/helpers.sh"

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    echo 'Usage: ./cloning_project.sh workspace_dir worktree_abilitate
    '
    exit
fi

main() {
    workspace_dir=$1
    worktree_abilitate=$2

    read -p "Provide git urls: " project_url && [ ! -z $project_url ] || exit 1
    project_name=`basename $project_url | sed 's/.git//g'`

    workspaces=($(basename -a $(ls -d $workspace_dir/*)))
    workspaces+=('New')
    workspace=$(for i in ${workspaces[@]}
           do
             echo $i
           done | fzf --prompt='Workspace>' ${fzf_args} && [ -z $workspace ] || exit 1)
    if [ $workspace = "New" ]; then
        read -p "Provide new workspace name: " workspace
        if [ -z $workspace ]; then
            exit 1
        fi
        mkdir $workspace_dir/$workspace
    fi
    groups=($(basename -a $(ls -d $workspace_dir/$workspace/* 2>/dev/null) 2>/dev/null))
    groups+=('New')
    group=$(for i in ${groups[@]}
           do
             echo $i
           done | fzf --prompt='Group>' ${fzf_args} && [ -z $group ] || exit 1)
    if [ $group = "New" ]; then
        read -p "Provide new group name: " group
        if [ -z $group ]; then
            exit 1
        fi
        mkdir $workspace_dir/$workspace/$group
    fi
    selected_project="$workspace/$group/$project_name"
    absolute_project_path="$workspace_dir/$workspace/$group/$project_name"

    if [ $(is_project_exists $workspace_dir/$workspace $group $project_name) == "false" ]; then
	(
	    source $workspace_dir/$workspace/.envrc 2>/dev/null
	    cd $workspace_dir/$workspace/$group
	    git clone $project_url $project_name/wt1
	)
    fi
    tmux_open_session $selected_project $absolute_project_path/wt1
}

main "$@"
