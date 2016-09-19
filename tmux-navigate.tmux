#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPTS_DIR="$CURRENT_DIR/scripts"

function navigation_setup() {
  local after bindkey cursor dir key isvim query select

  dir="$2"
  key="$(printf "%q" "$1")"

  tmux bind-key -n C-$1 run-shell "$SCRIPTS_DIR/navigate $key $dir"
}

navigation_setup 'h' 'L'
navigation_setup 'j' 'D'
navigation_setup 'k' 'U'
navigation_setup 'l' 'R'
