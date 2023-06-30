#!/usr/bin/env bash

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    echo 'Usage: ./open_project.sh workspace_dir
'
    exit
fi

main() {
	workspace_dir=$1
	full_projects=""
	workspaces=`ls -D -1 $workspace_dir`
	for workspace in $workspaces
	do
	    groups=`ls -D -1 $workspace_dir/$workspace`
	    for group in $groups
	    do
		projects=`ls -D -1 $workspace_dir/$workspace/$group`
		for project in $projects
		do
		    full_projects=`echo "$workspace/$group/$project;$full_projects"`
		done
	    done
	done
	selected_project=`echo $full_projects | awk -v RS='[;]' '{print $0}' | fzf`
	echo $selected_project
}

main "$@"
