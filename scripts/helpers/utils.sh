# shellcheck shell=bash
if [ "$SOURCED_UTILS" ]; then
  return
fi

SOURCED_UTILS=1

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HELPERS_DIR="$CURRENT_DIR"
SCRIPTS_DIR="$HELPERS_DIR/.."

EDITOR_NAVIGATION_PREFIX=""
DEFAULT_NAVIGATION_PREFIX="C-"

DEFAULT_LOCAL_DELAY=0.15
DEFAULT_REMOTE_DELAY=0.3

source "$HELPERS_DIR/logging_utils.sh"
source "$HELPERS_DIR/format_utils.sh"

function abs() {
  echo "$1" | tr -d -
}

function navigation_state() {
  tmux show-options -gqv @navigation-state
}

function navigation_mode() {
  [[ "$(client_key_table)" == "navigation" ]]
}

function issue_delay() {
  local default delay option pane

  pane=${1-$(pane_index)}

  if requires_remote_delay "$pane"; then
    option="@navigation-remote-delay"
    default=$DEFAULT_REMOTE_DELAY
  else
    option="@navigation-local-delay"
    default=$DEFAULT_LOCAL_DELAY
  fi

  delay=$(tmux show-options -gv $option 2> /dev/null || return $default)
  log_trace "Sleeping $delay"

  sleep "$delay"
  window_cursor_pos "$pane"
}

function select_key() {
  local dir editor

  dir=$1
  editor=$2
  
  case $editor in
    editor) prefix=$EDITOR_NAVIGATION_PREFIX ;;
    *) prefix=$DEFAULT_NAVIGATION_PREFIX ;;
  esac

  case $dir in
    L|left)
      echo $prefix"h"
      ;;
    R|right)
      echo $prefix"l"
      ;;
    U|up|top)
      echo $prefix"k"
      ;;
    D|down|bottom)
      echo $prefix"j"
      ;;
  esac
}

function can_select_pane() {
  case $1 in
    L) [[ $(pane_left) -gt 0 ]] ;;
    R) [[ $(pane_right) -lt $(($(window_width) - 1)) ]] ;;
    U) [[ $(pane_top) -gt 0 ]] ;;
    D) [[ $(pane_bottom) -lt $(($(window_height) - 1)) ]] ;;
  esac
}

function indent() {
  local level

  level=$1
  shift 1

  printf "%s" "$*" | sed "s/^/$(printf "%${level}s")/g"
}

function call() {
  log_debug "Calling $1 with: ${*:2}"

  "$SCRIPTS_DIR/$1" "${@:2}"
}

function errexit() {
  local err=$?
  set +o xtrace
  local code="${1:-1}"
  log_fatal "Error in $(basename "${BASH_SOURCE[1]}"):${BASH_LINENO[0]}. '${BASH_COMMAND}' exited with status $err. Exiting with status ${code}"
  exit "${code}"
}
