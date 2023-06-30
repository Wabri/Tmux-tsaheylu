#!/usr/bin/env bash

select_project() {
    workspace_dir=$1
    absolute_projects=`command ls -d $workspace_dir/*/*/*`
    projects="${absolute_projects//$workspace_dir\//}"
    selected_project=`echo $projects | awk -v RS='[ ]' '{print $0}' | fzf`
    echo $selected_project
}
