if [ $SOURCED_LOGGING_UTILS ]; then
  return
fi

SOURCED_LOGGING_UTILS=1

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HELPERS_DIR="$CURRENT_DIR"

LOG_LEVEL_OFF=0
LOG_LEVEL_INFO=1
LOG_LEVEL_DEBUG=2
LOG_LEVEL_TRACE=3

function log_file() {
  tmux show-options -gv @navigation-log-file 2> /dev/null || echo "tmux-navigate.log"
}

function log_level() {
  tmux show-options -gv @navigation-log-level 2> /dev/null || echo $LOG_LEVEL_OFF
}

function log_caller() {
  line=$1
  func=$2
  file="$(basename $3)"

  echo "$file ($func:$line)"
}

function log() {
  local debug file level

  level=$1
  shift 1

  if [ $(log_level) -lt $level ]; then
    return
  fi

  prefix="$(date -u '+[%D %T]')"
  if [ $(log_level) -ge $LOG_LEVEL_DEBUG ]; then
    prefix="$prefix $(log_caller "$@")"
  fi

  shift 3
  echo "$prefix - $@" >> "$(log_file)"
}

function log_info() {
  log $LOG_LEVEL_INFO $(caller 0)  "$@"
}

function log_debug() {
  log $LOG_LEVEL_DEBUG $(caller 0)  "$@"
}

function log_trace() {
  log $LOG_LEVEL_TRACE $(caller 0) "$@"
}
