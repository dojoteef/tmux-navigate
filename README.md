Tmux Navigate - The intuitive tmux navigation plugin
==================

Do you want to use vim-like navigation for `tmux`? Well you're in luck. This
plugin takes that concept to the next level. Have you ever:

- Tried to navigate within nested tmux sessions and been frustrated that you
  need to press the prefix key twice? 
- Accidentally try to navigate in a zoomed tmux pane only to have tmux resize
  all the panes?
- Had tmux wrap to the left most pane when you try to navigate right on the
  right most pane.

Well if those issues annoy you, then try this plugin. It aims to be an
intuitive approach to navigating tmux panes. It even works in nested tmux
sessions including those running on a remote machine (over ssh or mosh).

Usage
-----

If you've ever used vim you know that `h` moves left, `j` moves down, `k` moves
up, and `l` moves right. By default in order to move between windows you prefix
with `CTRL-W`, so to move one window to the left you would press `CTRL-W j`.
Well for quicker movement this plugin simply uses `CTRL-J` for the same motion.
This motion will work in tmux and if you want seamless navigation with tmux and
vim you will need to setup the appropriate key bindings in your ~/.vimrc.

Installation
------------

#### Requirements

- You must have a version of `sleep` that allows sleeping for fractions of a
  second (otherwise you have to live with a one second delay upon switching
  panes if using nesting). The GNU version of sleep has this functionality.

#### TPM

Use the Tmux Plugin Manager ([TPM][]) to easily install:
Simply add the following lines to your ~/.tmux.conf:

``` tmux
set -g @plugin 'dojoteef/tmux-navigate'

run '~/.tmux/plugins/tpm/tpm'
```

Configuration
-------------

#### Tmux

The way the plugin works is that it first checks if a nested application is
running. If so, it tries to forward the movement key to the application
and if the cursor does not move it then takes the action itself. If you are on
a slow ssh connection you may need to increase the delay between forwarding the
movement key and switching panes. The default value for local nesting (when
running vim) is `0.15 seconds` and for remote sessions `0.3 seconds`.

`set -g @navigation-local-delay '0.15'`
`set -g @navigation-remote-delay '0.30'`

**NOTE:** The remote delay has to be larger than the local delay and should
account for a round trip between your local and remote session, otherwise
unexpected movement may result.

#### Vim

If you want seamless between tmux and vim you will need to put something like
this in your ~/.vimrc:

``` vim
" Ctrl-J/K/L/H select split
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h
```

Troubleshooting
-------------

If something goes wrong the movement might be in a "stuck" state such that
navigation does not work correctly. Simply go to the pane where the navigation
is misbehaving and press your prefix key and C-q. So for example if your prefix
key is `C-a` you would press `C-a C-q` (you may need to press Escape or Ctrl-C
first if your terminal is in a weird state due to the malfunctioning movement).

Note that the two main reasons why movement gets "stuck" is due to either not
having a large enough `@navigation-remote-delay` or issuing movement commands
too quickly.

Caveat I have not tested this with mosh and with it's predicitive approach it
may more may not work correctly. If someone wants to try it and submit a PR I
would be happy to look it over.
