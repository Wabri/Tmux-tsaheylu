#!/usr/bin/env bash

CURRENT_DIR="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"

source "$CURRENT_DIR/src/open_project.sh"

workspace_dir="~/Workspaces"

tmux bind-key W display-popup -E "$CURRENT_DIR/src/open_project.sh $workspace_dir true"
