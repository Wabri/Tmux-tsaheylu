#!/usr/bin/env bash

git status >& /dev/null 
[[ $? -ne 0 ]] && echo 'Not a git repository' && exit 1

source "$(dirname $0)/helpers.sh"

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    echo 'Usage: ./gitworktree_management.sh workspace_dir worktree_abilitate
    '
    exit
fi

workspace_dir=$1
worktree_abilitate=$2

select_in_list() {
    prompt=$1
    local elements=("${@:2}")
    for i in "${elements[@]}"
    do
        echo $i
    done | fzf --prompt="$prompt>" && [ -z $selected ] || exit 1
}

available_worktrees() {
    while read -r line; do
	worktree_branch=`echo $line | awk '{print($3)}' | tr -d '[]'`
	current_branch=`git branch --show-current`
	if [[ $worktree_branch != $current_branch ]]; then
	    worktrees+=($worktree_branch)
	fi
    done <<< "`git worktree list`" 
    echo "${worktrees[@]}"
}

available_branches() {
    while read -r line; do
	branch=$(echo $line | awk '{print $1}' | sed 's/remotes\/origin\///g')
	# Remove the HEAD and current branch for local remotes branches fetched
	current_branch=`git branch --show-current`
	if [[ $branch == $current_branch || $branch == "HEAD" ]]; then
	    continue
	fi
	# BUG: 
	#     I dont know why the branch currently is put inside the branch 
	#     variable it becomes a grep string. should be a * because of the
	#     awk command. And this is why there is a grep string in this 
	#     condition below. I think there is something append with regex of
	#     some sort.
	# Continue if not the current branch or already local tree
	if [[ $branch != "grep" && $branch != "+" ]]; then
	    for tmp_branch in $branches
	    do
		if [[ $tmp_branch == $branch ]]; then
		    branch=""
		    break
		fi
	    done
	    if [[ $branch == "" ]]; then
		continue
	    fi
	    branches+=($branch)
	fi
    done <<< "`git branch --all`" 
    echo "${branches[@]}"
}

move_action() {
    worktrees=$(available_worktrees)

    if [ ${#worktrees[@]} -eq 0 ]; then
	echo "This is the only worktree active"
	read -p "Do you want to do something else? [y/N] " selected
	if [[ $selected == "y" ]]; then
	    main "$@"
	fi
	exit 1
    fi

    worktree=`select_in_list 'Worktree>' "${worktrees[@]}"`

    if [ -z $worktree ]; then
	echo "No worktree exists or selected"
	exit 1
    fi

    echo $worktree
}

add_action() {
    branches=$(available_branches)

    if [ ${#branches[@]} -eq 0 ]; then
	echo "No branch available"
	read -p "Do you want to do create a new one? [y/N] " selected
	if [[ $selected == "y" ]]; then
	    echo TODO: create new branch + worktree
	fi
	read -p "Do you want to do something else? [y/N] " selected
	if [[ $selected == "y" ]]; then
	    main "$@"
	fi
	exit 1
    fi

    branch=`select_in_list 'Add worktree from' "${branches[@]}"`

    if [ -z $branch ]; then
	echo "No branch with these name!"
	exit 1
    fi

    echo $branch
}

main() {
    actions=(Move Add Remove Leave)
    action=$(for i in ${actions[@]}
    do
        echo $i
    done | fzf --prompt='What do you want to do>')
    
    case "$action" in
        "Move") 
	    move_action
    	;;
        "Add")
	    add_action
    	;;
        "Remove") echo "TODO: Remove me"
    	;;
        *) echo "TODO: We are leaving"
    	;;
    esac
    
    exit 1
}

git fetch --prune --all
main "$@"
