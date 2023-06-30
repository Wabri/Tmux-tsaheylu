#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"

workspace_dir="~/Workspaces"

tmux bind-key W display-popup -E "$CURRENT_DIR/src/open_project.sh $workspace_dir true"

