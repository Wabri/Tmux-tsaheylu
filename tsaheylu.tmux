#!/usr/bin/env bash

source "$(dirname $0)/src/helpers.sh"

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"

workspace_dir=$(get_tmux_option "@worksace_dir" "~/Workspaces")
worktree_abilitate=$(get_tmux_option "@worktree_abilitate" "true")
bind_open_project=$(get_tmux_option "@bind_open_project" "W")
bind_cloning_project=$(get_tmux_option "@bind_cloning_project" "G")

tmux bind-key $bind_open_project display-popup -E "$CURRENT_DIR/src/open_project.sh $workspace_dir $worktree_abilitate"
tmux bind-key $bind_cloning_project display-popup -E "$CURRENT_DIR/src/cloning_project.sh $workspace_dir $worktree_abilitate"

