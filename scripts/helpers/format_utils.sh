# shellcheck shell=bash
if [ "$SOURCED_FORMAT_UTILS" ]; then
  return
fi

SOURCED_FORMAT_UTILS=1

function client_key_table() {
  local target="$1"
  tmux display-message -t "$target" -p "#{client_key_table}"
}

function client_tty() {
  local target="$1"
  tmux display-message -t "$target" -p "#{client_tty}"
}

function pane_index() {
  local target="$1"
  tmux display-message -t "$target" -p "#{pane_index}"
}

function pane_tty() {
  local target="$1"
  tmux display-message -t "$target" -p "#{pane_tty}"
}

function pane_top() {
  local target="$1"
  tmux display-message -t "$target" -p "#{pane_top}"
}

function pane_bottom() {
  local target="$1"
  tmux display-message -t "$target" -p "#{pane_bottom}"
}

function pane_left() {
  local target="$1"
  tmux display-message -t "$target" -p "#{pane_left}"
}

function pane_right() {
  local target="$1"
  tmux display-message -t "$target" -p "#{pane_right}"
}

function pane_height() {
  local target="$1"
  tmux display-message -t "$target" -p "#{pane_height}"
}

function pane_width() {
  local target="$1"
  tmux display-message -t "$target" -p "#{pane_width}"
}

function pane_cursor_x() {
  local target="$1"
  tmux display-message -t "$target" -p "#{cursor_x}"
}

function pane_cursor_y() {
  local target="$1"
  tmux display-message -t "$target" -p "#{cursor_y}"
}

function pane_cursor_pos() {
  echo "$(pane_cursor_x "$target"),$(pane_cursor_y "$target")"
}

function window_top() {
  echo 0
}

function window_bottom() {
  echo $(($(window_height "$@") - 1))
}

function window_left() {
  echo 0
}

function window_right() {
  echo $(($(window_width "$@") - 1))
}

function window_height() {
  local target="$1"
  tmux display-message -t "$target" -p "#{window_height}"
}

function window_width() {
  local target="$1"
  tmux display-message -t "$target" -p "#{window_width}"
}

function window_cursor_x() {
  local left target x
  target="$1"

  left="$(pane_left "$target")"
  x="$(pane_cursor_x "$target")"

  echo "$((left + x))"
}

function window_cursor_y() {
  local target top y
  target="$1"

  top="$(pane_top "$target")"
  y="$(pane_cursor_y "$target")"

  echo "$((top + y))"
}

function window_cursor_pos() {
  local target="$1"
  echo "$(window_cursor_x "$target"),$(window_cursor_y "$target")"
}
