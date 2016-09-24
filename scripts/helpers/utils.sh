if [ $SOURCED_UTILS ]; then
  return
fi

SOURCED_UTILS=1

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HELPERS_DIR="$CURRENT_DIR"
SCRIPTS_DIR="$CURRENT_DIR/.."

EDITOR_NAVIGATION_PREFIX=""
DEFAULT_NAVIGATION_PREFIX="C-"

DEFAULT_LOCAL_DELAY=0.15
DEFAULT_REMOTE_DELAY=0.3

source "$HELPERS_DIR/logging_utils.sh"
source "$HELPERS_DIR/format_utils.sh"

function abs() {
  echo "$1" | tr -d -
}

function add() {
  $(($1 + $2))
}

function sub() {
  $(($1 - $2))
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

  if requires_remote_delay $pane; then
    option="@navigation-remote-delay"
    default=$DEFAULT_REMOTE_DELAY
  else
    option="@navigation-local-delay"
    default=$DEFAULT_LOCAL_DELAY
  fi

  delay=$(tmux show-options -gv $option 2> /dev/null || return $default)
  log_trace "Sleeping $delay"

  sleep $delay
  window_cursor_pos $pane
}

function select_key() {
  local dir editor

  dir=$1
  editor=$2
  
  case $2 in
    editor) prefix=$EDITOR_NAVIGATION_PREFIX ;;
    *) prefix=$DEFAULT_NAVIGATION_PREFIX ;;
  esac

  case $1 in
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
