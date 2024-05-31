#!/usr/bin/env bash

# Copy from https://github.com/olimorris/tmux-pomodoro-plus/blob/main/scripts/helpers.sh#L3
get_tmux_option() {
	local option=$1
	local default_value=$2
	option_value=$(tmux show-option -gqv "$option")
	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

tmux_open_session() {
    project_name=$1
    project_path=$2
    tmux has-session -t $project_name >/dev/null

    if [ $? != 0 ]; then
	tmux new-session -d -s $project_name -c $project_path
        window_name="main"
        [[ $worktree_abilitate == "true" ]] && window_name="wt1"
	tmux rename-window -t $project_name:1 $window_name
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

select_template() {
    template_dir=$1
    absolute_projects=`command ls -d $template_dir/*`
    templates="${absolute_projects//$template_dir\//}"
    selected_template=`echo $templates | awk -v RS='[ ]' '{print $0}' | fzf` 
    echo $selected_template
}

apply_template() {
    absolute_template_path=$1
    find "$absolute_template_path" -type f | while read -r file 
    do
        cat $file >> `basename $file`
    done
    echo $selected_template >> .template.tsaheylu
}

