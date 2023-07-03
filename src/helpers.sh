#!/usr/bin/env bash

tmux_open_session() {
    project_name=$1
    project_path=$2
    echo $project_name
    echo $project_path
    tmux has-session -t $project_name >/dev/null

    if [ $? != 0 ]; then
	tmux new-session -d -s $project_name -c $project_path
	tmux rename-window -t $project_name:1 "wt1"
    fi

    tmux switch-client -t $project_name
}

select_project() {
    workspace_dir=$1
    absolute_projects=`command ls -d $workspace_dir/*/*/*`
    projects="${absolute_projects//$workspace_dir\//}"
    selected_project=`echo $projects | awk -v RS='[ ]' '{print $0}' | fzf`
    echo $selected_project
}

is_project_exists() {
    workspace=$1
    group=$2
    project=$3
    if [ -d "$workspace/$group/$project" ]; then
        echo true
    else
        echo false
    fi
}
