# ________________________________ Bashrc ________________________________
#
# _____ Interattiva
case $- in
    *i*) ;;
      *) return;;
esac
# _____ Alias
if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi
# _____ Profili
for SH in /etc/profile.d/*.sh; do
       . $SH
done
# _____ Alias .sh
for sh in /etc/bash/bashrc.d/* ; do
	[[ -r ${sh} ]] && source "${sh}"
done
# ________________________________ Direttive ________________________________
export GPG_TTY=$(tty)
export TERM="xterm"
export EDITOR="nano"
export BROWSER="firefox-bin"
export WEBBROWSER="firefox-bin"
export FILEMANAGER='thunar"
export LC_TYPE="it_IT.UTF-8"
export LANG="it_IT.UTF-8'
export XDG_CONFIG_HOME="$HOME/.config"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/lib/pkgconfig"
export WIKI="$HOME/Wiki"
export SCRIPT="$HOME/Scripts"
export DOTFILE="$HOME/Dotfiles"
#
# ________________     ________________     ________________    ____________
export MANWIDTH=90
export HISTSIZE=10000
export HISTIGNORE="q:f:v"
#
set -o vi
set -o notify
#
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
# ________________________________ Colori Ansi ________________________________
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac
# __________________
red='\[\e[0;31m\]'
blue='\[\e[0;34m\]'
cyan='\[\e[0;36m\]'
green='\[\e[0;32m\]'
yellow='\[\e[0;33m\]'
purple='\[\e[0;35m\]'
nc='\[\e[0m\]'
# __________________
export PS1="\[\e[0;32m\][\@]\[\e[0;34m\]{\u}\[\e[0;32m\]@\[\e[0;35m\][\H]\[\e[0;32m\]{\w}\[\e[0;35m\]\\$\[$(tput sgr0)\]"
export LESS_TERMCAP_mb=$'\e[01;31m'
export LESS_TERMCAP_md=$'\e[01;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[01;32m'
#
#
# ________________________________ Utilità TTY ________________________________
#
arc()
{
    arg="$1"; shift
    case $arg in
        -e|--extract)
            if [[ $1 && -e $1 ]]; then
                case $1 in
                    *.tbz2|*.tar.bz2) tar xvjf "$1" ;;
                    *.tgz|*.tar.gz) tar xvzf "$1" ;;
                    *.tar.xz) tar xpvf "$1" ;;
                    *.tar) tar xvf "$1" ;;
                    *.gz) gunzip "$1" ;;
                    *.zip) unzip "$1" ;;
                    *.bz2) bunzip2 "$1" ;;
                    *.7zip) 7za e "$1" ;;
                    *.rar) unrar x "$1" ;;
                    *) printf "'%s' non può essere estratto" "$1"
                esac
            else
                printf "'%s' non è un file valido" "$1"
            fi ;;
        -n|--new)
            case $1 in
                *.tar.*)
                    name="${1%.*}"
                    ext="${1#*.tar}"; shift
                    tar cvf "$name" "$@"
                    case $ext in
                        .gz) gzip -9r "$name" ;;
                        .bz2) bzip2 -9zv "$name"
                    esac ;;
                *.gz) shift; gzip -9rk "$@" ;;
                *.zip) zip -9r "$@" ;;
                *.7z) 7z a -mx9 "$@" ;;
                *) printf "estensione non valida/non supportata"
            esac ;;
        *) printf "argomento non valido '%s'" "$arg"
    esac
}

killp()
{
    local pid name sig="-TERM"   # default signal
    [[ $# -lt 1 || $# -gt 2 ]] && printf "Utilizza: killp [-SIGNAL] pattern" && return 1
    [[ $# -eq 2 ]] && sig=$1
    for pid in $(mp | awk '!/awk/ && $0~pat { print $1 }' pat=${!#}); do
        name=$(mp | awk '$1~var { print $5 }' var=$pid)
        ask "Kill process $pid <$name> with signal $sig?" && kill $sig $pid
    done
}

mdf()
{
    local cols
    cols=$(( ${COLUMNS:-$(tput cols)} / 3 ))
    for fs in "$@"; do
        [[ ! -d $fs ]] && printf "%s :Nessun file o directory con questo nome" "$fs" && continue
        local info=($(command df -P $fs | awk 'END{ print $2,$3,$5 }'))
        local free=($(command df -Pkh $fs | awk 'END{ print $4 }'))
        local nbstars=$((cols * info[1] / info[0]))
        local out="["
        for ((i=0; i<cols; i++)); do
            [[ $i -lt $nbstars ]] && out=$out"*" || out=$out"-"
        done
        out="${info[2]} $out] (${free[*]} free on $fs)"
        printf "%s" "$out"
    done
}

mip()
{
    local ip
    ip=$(/bin/ifconfig "$(ifconfig | awk -F: '/RUNNING/ && !/LOOP/ {print $1}')" |
        awk '/inet/ { print $2 } ' | sed -e s/addr://)
    printf "%s" "${ip:-Non connesso}"
}

ii()
{
    echo -e "\nSei connesso in \e[1;31m$HOSTNAME"
    echo -e "\n\e[1;31mInformazioni aggiuntive:\e[m " ; uname -a
    echo -e "\n\e[1;31mUtenti loggati:\e[m "         ; w -hs | awk '{print $1}' | sort | uniq
    echo -e "\n\e[1;31mData Odierna:\e[m "            ; date
    echo -e "\n\e[1;31mStatistiche della Macchina:\e[m "           ; uptime
    echo -e "\n\e[1;31mStatistiche della Memoria:\e[m "            ; free
    echo -e "\n\e[1;31mSpazio sul Disco:\e[m "               ; mdf / $HOME
    echo -e "\n\e[1;31mIndirizzo IP Locale:\e[m"         ; mip
    echo -e "\n\e[1;31mConnessioni Aperte:\e[m "        ; netstat -pan --inet;
    echo
}
#
# _____________________________________  Fine  _______________________________________


