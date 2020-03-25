#!/bin/bash
#================================================
#================================================
#   O.S.      : Gnu Linux                       =
#   Author    : Cristian Pozzessere   = ilnanny =
#   D.A.Page  : http://ilnanny.deviantart.com   =
#   Github    : https://github.com/ilnanny      =
#================================================
#================================================

#  ________________________________    Utilità TTY    ________________________________
#
## ___  Extract Files
extract()
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

#
## ___   Kill Pid
killp()
{
    local pid name sig="-TERM"   # segnale di default
    [[ $# -lt 1 || $# -gt 2 ]] && printf "Utilizza: killp [-SIGNAL] pattern" && return 1
    [[ $# -eq 2 ]] && sig=$1
    for pid in $(mp | awk '!/awk/ && $0~pat { print $1 }' pat=${!#}); do
        name=$(mp | awk '$1~var { print $5 }' var=$pid)
        ask "Kill process $pid <$name> with signal $sig?" && kill $sig $pid
    done
}

#
## ___   My IP
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
## ___   Gentoo Wgetpaste
#
if ${use_color} ; then
       alias emerge='emerge --color=y'
       alias eix='eix -F'
fi
#
# ___            Fine

