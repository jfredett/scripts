#source "$HOME/scripts/tmuxen.sh"
tmux new -d -s irc {weechat-curses}
bash $HOME/scripts/tmux-scripts/no-status.sh irc

