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
intuitive approach to navigating tmux panes.

**BEWARE** If you are using this plugin with ssh running in a tmux pane it will
assume you have tmux running within the ssh session. That means it will send
the key presses such as `CTRL-H` to the ssh pane which could for example result
in a Backspace deleting a character in your ssh session. So either do not put
ssh in a tmux pane or make sure tmux is running in your ssh sessions.

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
movement key and switching panes. The default value is `0.1 seconds`.

`set -g @navigation-delay '0.1'`

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
