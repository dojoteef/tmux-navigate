if [ $SOURCED_PS_UTILS ]; then
  return
fi

SOURCED_PS_UTILS=1

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HELPERS_DIR="$CURRENT_DIR"

source "$HELPERS_DIR/format_utils.sh"

function is_running() {
  local regex tty

  regex=$1
  tty=$(pane_tty $2)

  ps -o stat= -o comm= -t "$tty" | \
    grep -iE "^[^TXZ ]+ +(\\S+\\/)?$regex$" &> /dev/null
}

function is_running_editor() {
  is_running "(e|g|r|rg)?(view|n?vim?x?)(diff)?" "$@"
}

function is_running_remote() {
  is_running "mosh|ssh" "$@"
}

function is_running_tmux() {
  is_running "tmux" "$@"
}

function requires_remote_delay() {
  is_running_remote "$@" || is_running_tmux "$@"
}

function requires_delay() {
  requires_remote_delay "$@" || is_running_editor "$@"
}
