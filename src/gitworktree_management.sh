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

select_worktree_in_list() {
    prompt=$1
    local elements=("${@:2}")
    for i in "${elements[@]}"
    do
        echo $i
    done | fzf --prompt="$prompt>" && [ -z $selected ] || exit 1
}

main() {
    actions=(Move Add Remove Leave)
    action=$(for i in ${actions[@]}
    do
        echo $i
    done | fzf --prompt='What do you want to do>')
    
    case "$action" in
        "Move") 
	    while read -r line; do
		worktree_list+=($(echo $line | awk '{print($3)}' | tr -d '[]'))
	    done <<< "`git worktree list`" 
	
	    worktree=`select_worktree_in_list 'Worktree>' "${worktree_list[@]}"`

	    if [ -z $worktree ]; then
		echo "No worktree exists or selected"
		exit 1
	    fi
    	;;
        "Add") echo "TODO: Add me"
    	;;
        "Remove") echo "TODO: Remove me"
    	;;
        *) echo "TODO: We are leaving"
    	;;
    esac
    
    exit 1
}

main "$@"
