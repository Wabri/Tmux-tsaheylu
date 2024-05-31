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

create_if_new() {
    base_path=$1
    selected=$2
    prompt=$3
    if [[ $selected == "New" ]]; then
        read -p "Provide new $prompt name: " selected
        if [ -z $selected ]; then
            exit 1
        fi
        mkdir $base_path/$selected
    fi
    echo $selected
}

select_element_from() {
    prompt=$1
    local elements=("${@:2}")
    selected=""
    for i in "${elements[@]}"
    do
        echo $i
    done | fzf --prompt="$prompt>" && [ -z $selected ] || exit 1
}

clone_if_not_exists() {
    workspace=$1
    group=$2
    project_name=$3
    project_url=$4
    if [[ $(is_project_exists $workspace_dir/$workspace $group $project_name) == "false" ]]; then
	(
	    source $workspace_dir/$workspace/.envrc 2>/dev/null
	    cd $workspace_dir/$workspace/$group
        [[ $worktree_abilitate == "true" ]] && project_name="$project_name/wt1"
	    git clone $project_url $project_name
	    cd $workspace_dir/$workspace/$group/$project_name
        apply_template $template_dir/default
    )
    fi
}

main() {
    # Read git url
    read -p "Provide git urls: " project_url && [ ! -z $project_url ] || exit 1
    project_name=`basename $project_url | sed 's/.git//g' | sed 's/\./_/g'`

    # Select Workspace
    workspaces=($(basename -a $(ls -d $workspace_dir/* 2>/dev/null) 2>/dev/null))
    workspaces+=('New')
    workspace=`select_element_from 'Workspace' "${workspaces[@]}"`
    [ -z $workspace ] && exit 1
    workspace=`create_if_new $workspace_dir $workspace 'workspace'`

    # Select Group
    groups=($(basename -a $(ls -d $workspace_dir/$workspace/* 2>/dev/null) 2>/dev/null))
    groups+=('New')
    group=`select_element_from 'Group' "${groups[@]}"`
    [ -z $group ] && exit 1
    group=`create_if_new $workspace_dir/$workspace $group 'group'`

    # Clone project if not exists
    selected_project="$workspace/$group/$project_name"
    clone_if_not_exists $workspace $group $project_name $project_url

    # Open project in the dedicated session
    session_name="$workspace_dir/$selected_project"
    [[ $worktree_abilitate == "true" ]] && session_name="$session_name/wt1"
    tmux_open_session $selected_project $session_name
}

main "$@"

