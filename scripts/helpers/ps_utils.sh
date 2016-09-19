function get_tty() {
  tmux display-message -p "#{pane_tty}"
}

function is_running() {
  ps -o state= -o comm= -t "$(get_tty)" | grep -iqE "^[^TXZ ]+ +(\\S+\\/)?$1$"
}

function is_running_editor() {
  is_running "(e|g|r|rg)?(view|n?vim?x?)(diff)?"
}

function is_running_remote() {
  is_running "mosh|ssh"
}

function is_running_tmux() {
  is_running "tmux"
}
