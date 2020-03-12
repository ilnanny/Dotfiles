#!/bin/bash
#================================================
#================================================
#   O.S.      : Gnu Linux                       =
#   Author    : Cristian Pozzessere   = ilnanny =
#   D.A.Page  : http://ilnanny.deviantart.com   =
#   Github    : https://github.com/ilnanny      =
#================================================
#================================================

# ________________________  Direttive
export XKBMAP="it"
export TERM="xterm"
export EDITOR="nano"
export MANWIDTH=90
export HISTSIZE=10000
export GPG_TTY=$(tty)
export BROWSER="firefox"
export FILEMANAGER"thunar"
export HISTIGNORE="q:f:v"
export LANG="it_IT.UTF-8"
export LC_TYPE="it_IT.UTF-8"
export PATH="$HOME/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/lib/pkgconfig:$PATH"

# ________________________  Colori Ansi
red='\[\e[0;31m\]'
blue='\[\e[0;34m\]'
cyan='\[\e[0;36m\]'
green='\[\e[0;32m\]'
nc='\[\e[0m\]'

# ________________________  Terminale
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# ________________________  Less
export LESS_TERMCAP_it="${red}"
export LESS_TERMCAP_mb="${red}"
export LESS_TERMCAP_md="${red}"
export LESS_TERMCAP_me="${nc}"
export LESS_TERMCAP_se="${nc}"
export LESS_TERMCAP_so="${cyan}"
export LESS_TERMCAP_ue="${nc}"
export LESS_TERMCAP_us="${green}"

# ________________________  Git
SCM_THEME_PROMPT_DIRTY="${red}✗"
SCM_THEME_PROMPT_CLEAN="${cyan}✓"
SCM_THEME_PROMPT_PREFIX=" |"
SCM_THEME_PROMPT_SUFFIX="${green}|"
GIT_THEME_PROMPT_DIRTY="${red}✗"
GIT_THEME_PROMPT_CLEAN="${blue}✓"
GIT_THEME_PROMPT_PREFIX="${green}|"
GIT_THEME_PROMPT_SUFFIX="${green}|"
CONDAENV_THEME_PROMPT_SUFFIX="|"

# ________________________  Shell

PS1="┌─[\`if [ \$? = 0 ]; then echo \[\e[32m\]✔\[\e[0m\]; else echo \[\e[31m\]✘\[\e[0m\]; fi\`]───[\[\e[01;49;39m\]\u\[\e[00m\]\[\e[01;49;39m\]@\H\[\e[00m\]]───[\[\e[1;49;34m\]\W\[\e[0m\]]───[\[\e[1;49;39m\]\$(ls | wc -l) files, \$(ls -lah | grep -m 1 total | sed 's/total //')\[\e[0m\]]\n└───▶ "

# ________________________  Fine
