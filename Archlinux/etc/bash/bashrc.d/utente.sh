#!/bin/bash
#================================================
#================================================
#   O.S.      : Gnu Linux                       =
#   Author    : Cristian Pozzessere   = ilnanny =
#   D.A.Page  : http://ilnanny.deviantart.com   =
#   Github    : https://github.com/ilnanny      =
#================================================
#================================================

# ___________________________________________   Colori Ansi
red='\[\e[0;31m\]'
blue='\[\e[0;34m\]'
cyan='\[\e[0;36m\]'
green='\[\e[0;32m\]'
nc='\[\e[0m\]'

# ___________________________________________  256 Colori
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# ___________________________________________  Direttive
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
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# ___________________________________________  Less
export LESS_TERMCAP_it="${red}"
export LESS_TERMCAP_mb="${red}"
export LESS_TERMCAP_md="${red}"
export LESS_TERMCAP_me="${nc}"
export LESS_TERMCAP_se="${nc}"
export LESS_TERMCAP_so="${cyan}"
export LESS_TERMCAP_ue="${nc}"
export LESS_TERMCAP_us="${green}"

# ________________________  Git
export SCM_THEME_PROMPT_DIRTY="${red}✗"
export SCM_THEME_PROMPT_CLEAN="${cyan}✓"
export SCM_THEME_PROMPT_PREFIX=" |"
export SCM_THEME_PROMPT_SUFFIX="${green}|"
export GIT_THEME_PROMPT_DIRTY="${red}✗"
export GIT_THEME_PROMPT_CLEAN="${blue}✓"
export GIT_THEME_PROMPT_PREFIX="${green}|"
export GIT_THEME_PROMPT_SUFFIX="${green}|"
export CONDAENV_THEME_PROMPT_SUFFIX="|"

# ___________________________________________  Fine
