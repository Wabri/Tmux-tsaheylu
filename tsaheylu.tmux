#!/usr/bin/env bash

source "$(dirname $0)/src/helpers.sh"

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"

workspace_dir=$(get_tmux_option "@worksace_dir" "~/Workspaces")
worktree_abilitate=$(get_tmux_option "@worktree_abilitate" "true")
template_dir=$(get_tmux_option "@template_dir" "~/Templates")

# binding options
bind_open_project=$(get_tmux_option "@bind_open_project" "W")
bind_cloning_project=$(get_tmux_option "@bind_cloning_project" "G")
bind_worktree_management=$(get_tmux_option "@bind_worktree_management" "g")
bind_new_project=$(get_tmux_option "@bind_new_project" "N")
bind_template_selection=$(get_tmux_option "@bind_template_selection" "T")

if [[ "$(tmux -V)" > "tmux 3.2" ]]; then
  command="display-popup -E"
else
  command="split-window"
fi

tmux bind-key $bind_open_project $command "$CURRENT_DIR/src/open_project.sh $workspace_dir $worktree_abilitate $template_dir"
tmux bind-key $bind_cloning_project $command "$CURRENT_DIR/src/cloning_project.sh $workspace_dir $worktree_abilitate $template_dir"
tmux bind-key $bind_worktree_management $command "$CURRENT_DIR/src/gitworktree_management.sh $workspace_dir $worktree_abilitate $template_dir"
tmux bind-key $bind_new_project $command "$CURRENT_DIR/src/new_project.sh $workspace_dir $worktree_abilitate $template_dir"
tmux bind-key $bind_template_selection $command "$CURRENT_DIR/src/apply-template.sh $workspace_dir $worktree_abilitate $template_dir"

