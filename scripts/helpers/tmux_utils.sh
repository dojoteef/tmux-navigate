# shellcheck shell=bash
if [ "$SOURCED_TMUX_UTILS" ]; then
  return
fi

SOURCED_TMUX_UTILS=1

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HELPERS_DIR="$CURRENT_DIR"

source "$HELPERS_DIR/logging_utils.sh"

function send_keys() {
  log_trace "Send keys \"$*\""
  tmux send-keys "$@"
}
