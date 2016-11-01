# shellcheck shell=bash
if [ "$SOURCED_LOGGING_UTILS" ]; then
  return
fi

SOURCED_LOGGING_UTILS=1

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HELPERS_DIR="$CURRENT_DIR" # shellcheck disable=SC2034

LOG_LEVEL_OFF=0
LOG_LEVEL_FATAL=1
LOG_LEVEL_ERROR=2
LOG_LEVEL_INFO=3
LOG_LEVEL_DEBUG=4
LOG_LEVEL_TRACE=5

function log_file() {
  tmux show-options -gv @navigation-log-file 2> /dev/null || echo "tmux-navigate.log"
}

function log_level() {
  tmux show-options -gv @navigation-log-level 2> /dev/null || echo $LOG_LEVEL_OFF
}

function log_caller() {
  local frame

  if [ "$1" ]; then
    frame="$1"
  else
    frame=0
  fi

  while log_caller_frame "$((frame + 1))"; do
    ((frame++));
  done
}

function log_caller_frame() {
  local file frame func line params

  frame=$1
  params=($(caller "$((frame + 1))"))
  if [ $? -ne 0 ]; then
    return 1
  fi

  line=${params[0]}
  func=${params[1]}
  file="$(basename "${params[2]}")"

  echo "$file ($func:$line)"
}

function log() {
  local level logline

  level=$1
  shift 1

  if [ "$(log_level)" -lt "$level" ]; then
    return
  fi

  logline="$(date -u '+[%D %T]') - $*"
  if [ "$(log_level)" -ge "$LOG_LEVEL_DEBUG" ]; then
    traceback="$(log_caller 1)"
    traceback="$(\
      printf "traceback: %s\n%s" \
      "$(echo "$traceback" | head -n 1)" \
      "$(indent 11 "$(echo "$traceback" | tail -n +2)")" \
    )"

    logline="$(printf "%s\n%s" "$logline" "$traceback")"
  fi

  echo "$logline" >> "$(log_file)"
}

function log_fatal() {
  local params

  params=($LOG_LEVEL_FATAL "$@")
  log "${params[@]}"
}

function log_error() {
  local params

  params=($LOG_LEVEL_ERROR "$@")
  log "${params[@]}"
}

function log_info() {
  local params

  params=($LOG_LEVEL_INFO "$@")
  log "${params[@]}"
}

function log_debug() {
  local params

  params=($LOG_LEVEL_DEBUG "$@")
  log "${params[@]}"
}

function log_trace() {
  local params

  params=($LOG_LEVEL_TRACE "$@")
  log "${params[@]}"
}
