#================================================
#================================================
#   O.S.      : Gnu Linux                       =
#   Author    : Cristian Pozzessere   = ilnanny =
#   D.A.Page  : http://ilnanny.deviantart.com   =
#   Github    : https://github.com/ilnanny      =
#================================================
#================================================
#
#  ________________________________    Direttive    ________________________________
export GPG_TTY=$(tty)
export TERM="xterm"
export EDITOR="nano"
export BROWSER="firefox-bin"
export WEBBROWSER="firefox"
export FILEMANAGER='thunar"
export LC_TYPE="it_IT.UTF-8"
export LANG="it_IT.UTF-8'
export XDG_CONFIG_HOME="$HOME/.config"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export PATH="$HOME/bin:$PATH"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/lib/pkgconfig:$PATH"
export WIKI="$HOME/Wiki:$PATH"
export SCRIPT="$HOME/Scripts:$PATH"
export DOTFILE="$HOME/Dotfiles:$PATH"
export LOCALBIN="$HOME/.local/bin:$PATH"
export HOMEBIN="$HOME/bin:$PATH"
#
export MANWIDTH=90
export HISTSIZE=10000
export HISTIGNORE="q:f:v"
shopt -s direxpand
shopt -s checkhash
shopt -s sourcepath
shopt -s expand_aliases
shopt -s autocd cdspell
shopt -s extglob dotglob
shopt -s no_empty_cmd_completion
shopt -s autocd cdable_vars cdspell
shopt -s cmdhist histappend histreedit histverify
[[ $DISPLAY ]] && shopt -s checkwinsize
#
#
#  ________________________________    Colori Ansi     ________________________________
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac
#
red='\[\e[0;31m\]'
blue='\[\e[0;34m\]'
cyan='\[\e[0;36m\]'
green='\[\e[0;32m\]'
yellow='\[\e[0;33m\]'
purple='\[\e[0;35m\]'
nc='\[\e[0m\]'
export LESS_TERMCAP_it=$'\e[01;31m'
export LESS_TERMCAP_mb=$'\e[01;31m'
export LESS_TERMCAP_md=$'\e[01;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[01;32m'
#
#  ________________________________     Git     ________________________________
#
SCM_THEME_PROMPT_DIRTY=" ${red}✗"
SCM_THEME_PROMPT_CLEAN=" ${bold_green}✓"
SCM_THEME_PROMPT_PREFIX=" |"
SCM_THEME_PROMPT_SUFFIX="${green}|"

GIT_THEME_PROMPT_DIRTY=" ${red}✗"
GIT_THEME_PROMPT_CLEAN=" ${bold_green}✓"
GIT_THEME_PROMPT_PREFIX=" ${green}|"
GIT_THEME_PROMPT_SUFFIX="${green}|"

CONDAENV_THEME_PROMPT_SUFFIX="|"

#  ________________________________     Shell  Utente     ________________________________
#
#
PS1="┌─[\`if [ \$? = 0 ]; then echo \[\e[32m\]✔\[\e[0m\]; else echo \[\e[31m\]✘\[\e[0m\]; fi\`]───[\[\e[01;49;39m\]\u\[\e[00m\]\[\e[01;49;39m\]@\H\[\e[00m\]]───[\[\e[1;49;34m\]\W\[\e[0m\]]───[\[\e[1;49;39m\]\$(ls | wc -l) files, \$(ls -lah | grep -m 1 total | sed 's/total //')\[\e[0m\]]\n└───▶ "
#
#
# _____________________________________  Fine  _______________________________________

