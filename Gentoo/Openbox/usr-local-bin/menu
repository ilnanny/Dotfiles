#!/usr/bin/env bash
#================================================
#================================================
#   O.S.      : Gnu Linux                       =
#   Author    : Cristian Pozzessere   = ilnanny =
#   D.A.Page  : http://ilnanny.deviantart.com   =
#   Github    : https://github.com/ilnanny      =
#================================================
#================================================
# Questo script ha bisogno del software 'rofi' per funzionare!!
# (https://github.com/davatorium/rofi)
# Altro software:
#'libqualculate'   =calcolatrice-cli.
#'surfraw'         =ricerca nel web-cli.
#'greenclip'       =clipboard-cli.
#(https://github.com/erebe/greenclip)
#  _______________       ______________   ________________   ____#

Name=$(basename "$0")
Version="0.1"

_usage() {
    cat <<- EOF
Usage:   $Name [options]

Options:
     -h      Visualizza questo messaggio
     -v      Visualizza la versione dello script
     -q      Calcolatrice a linea di comando
     -w      Passa tra le finestre aperte
     -r      Programmi di avvio / eseguibili
     -m      Menu Personalizzato
     -c      Clipboard a linea di comando
     -b      Cerca per parola chiave sul web
     -l      Menu per uscire dalla Sessione 

EOF
}

#  Gestione dalla riga di comando
while getopts ":hvqwcbmrl" opt; do
    case $opt in
        h)
            _usage
            exit 0
            ;;
        v)
            echo -e "$Name -- Version $Version"
            exit 0
            ;;
        q)
            rofi -modi "calc:qalc +u8 -nocurrencies" -padding 10 \
                -show "calc:qalc +u8 -nocurrencies" -line-padding 4 \
                -hide-scrollbar
            ;;
        w)
            rofi -modi window -show window -hide-scrollbar \
                -eh 1 -padding 10 -line-padding 4
            ;;
        c)
            rofi -modi "clipboard:greenclip print" -padding 10 \
                -line-padding 4 -show "clipboard:greenclip print" \
                -hide-scrollbar
            ;;
        b)
            surfraw -browser="$BROWSER" $(sr -elvi | awk -F'-' '{print $1}' \
                | sed '/:/d' | awk '{$1=$1};1' | rofi -hide-scrollbar \
                -kb-row-select 'Tab' -kb-row-tab 'Control+space' \
                -dmenu -mesg 'Tab for Autocomplete' -i -p 'Web Search: ' \
                -padding 10 -line-padding 4)
            ;;
        m)
            rofi -location 1 -yoffset 35 -xoffset 45 \
                -modi run,drun -show drun -line-padding 10 \
                -columns 3 -padding 10 -hide-scrollbar \
                -show-icons -drun-icon-theme "Lila_HD"
            ;;
        r)
            rofi -modi run,drun -show drun -line-padding 10 \
                -columns 3 -padding 10 -hide-scrollbar \
                -show-icons -drun-icon-theme "Lila_HD"
            ;;
        l)
            ANS=$(echo "  Blocco   Schermo |  Chiudi   Sessione |  Riavvia  Computer |  Spegni   Computer"| \
                rofi -sep "|" -dmenu -i -p 'Esegui' "" -width 12 \
                -hide-scrollbar -eh 1 -line-padding 4 -padding 12 -lines 4)
            case "$ANS" in
                *Lockscreen) lockscreen -- scrot ;;
                *Esci) openbox --exit ;;
                *Riavvia) xterm -e sudo shutdown -r now ;;
                *Spegni) xterm -e sudo shutdown -h now
            esac
            ;;
        *)
            echo -e "Opzione inesistente: -$OPTARG"
            _usage
            exit 1
    esac
done
shift $((OPTIND - 1))


exit 0


