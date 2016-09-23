#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPTS_DIR="$CURRENT_DIR/scripts"
HELPERS_DIR="$SCRIPTS_DIR/helpers"

source "$HELPERS_DIR/utils.sh"

REMOTE="$SCRIPTS_DIR/remote"
NAVIGATE="$SCRIPTS_DIR/navigate"

function navigation_setup() {
  tmux set-option -g @navigation-state "idle"
  tmux bind-key C-q run-shell "$REMOTE reset all"
  tmux bind-key -r -n C-s run-shell "$REMOTE begin"
  tmux bind-key -r -Tnavigation C-q run-shell "$REMOTE reset"

  for i in $(seq 0 9); do
    tmux bind-key -r -Tnavigation $i run-shell "$REMOTE receive $i"
  done
}

function navigation_setup_key() {
  local dir ekey key

  dir="$1"
  key="$(select_key $dir)"
  ekey="$(select_key $dir "editor")"

  tmux bind-key -n $key run-shell "$NAVIGATE local $dir"
  tmux bind-key -r -Tnavigation $key run-shell "$REMOTE navigate $dir"
  tmux bind-key -r -Tnavigation $ekey run-shell "$REMOTE navigate-editor $dir"
}

navigation_setup
navigation_setup_key 'L'
navigation_setup_key 'D'
navigation_setup_key 'U'
navigation_setup_key 'R'
