#!/bin/bash
#================================================
#================================================
#   O.S.      : Gnu Linux                       =
#   Author    : Cristian Pozzessere   = ilnanny =
#   D.A.Page  : http://ilnanny.deviantart.com   =
#   Github    : https://github.com/ilnanny      =
#================================================
#================================================

function update
{
        #comando per aggiornare il sistema
        sudo xbps-install -Suv
}

function install
{
    #dichiarazione di variabili localii
    local pkg
    local argument_input

echo ="__ __ __ __ __ __ __ Selezione dei pacchetti da Installare __ __ __ __ __ __ __ __ __
_ flags multi     |per selezionare più pacchetti
_ exact           |per corrispondere alla corrispondenza esatta
_ no-sort         |auto esplicativo
_ cycle           |per abilitare il ciclo di scorrimento
_ reverse         |per impostare l'orientamento al contrario
_ margin          |per i margini
_ inline info     |per visualizzare informazioni in linea
_ preview         |per mostrare la descrizione del pacchetto
_ header e prompt |per dare informazioni per eseguire bene i comandi"
    pkg="$( xbps-query -Rs "" | sort -u | grep -v "*" | fzf -i \
                    --multi --exact --no-sort --select-1 --query="$argument_input" \
                    --cycle --reverse --margin="4%,1%,1%,2%" \
                    --inline-info \
                    --preview 'xbps-query -R {2} '\
                    --preview-window=right:55%:wrap \
                    --header="Tasto TAB per (dis) selezionare.\
                      INVIO per eliminare. ESC per chiudere." \
                    --prompt="filter> " | awk '{print $2}'
            )"
            pkg="$( echo "$pkg" | paste -sd " " )"
            if [[ -n "$pkg" ]]
            then
            clear
            sudo xbps-install -S $pkg
            fi
}

function purge
{
    local pkg
    local argument_input
    pkg="$( xbps-query -l | sort -u |
        fzf -i \
                    --multi \
                    --exact \
                    --no-sort \
                    --select-1 \
                    --query="$argument_input" \
                    --cycle \
                    --reverse \
                    --margin="4%,1%,1%,2%" \
                    --inline-info \
                    --preview 'xbps-query -S {2} '\
                    --preview-window=right:55%:wrap \
                    --header="Tasto TAB per (dis) selezionare. INVIO per eliminare. ESC per chiudere." \
                    --prompt="filter> " |
                awk '{print $2}'
            )"

            pkg="$( echo "$pkg" | paste -sd " " )"
            if [[ -n "$pkg" ]]
            then
            clear
            sudo xbps-remove -R $pkg
            fi
}

function unhold
{
    local pkg
    local argument_input
    pkg="$( xbps-query -p hold -s "" | sort -u |
        fzf -i \
                    --multi \
                    --exact \
                    --no-sort \
                    --select-1 \
                    --query="$argument_input" \
                    --cycle \
                    --reverse \
                    --margin="4%,1%,1%,2%" \
                    --inline-info \
                    --header="Tasto TAB per (dis) selezionare. INVIO per eliminare. ESC per chiudere." \
                    --prompt="filter> " |
                awk '{print $1}'
            )"

            pkg="$( echo "$pkg" | paste -sd " "| tr -d ":" )"
            if [[ -n "$pkg" ]]
            then
            clear
            sudo xbps-pkgdb -m unhold $pkg
            fi
}

function hold
{
    local pkg
    local argument_input
    pkg="$( xbps-query -l | sort -u |
        fzf -i \
                    --multi \
                    --exact \
                    --no-sort \
                    --select-1 \
                    --query="$argument_input" \
                    --cycle \
                    --reverse \
                    --margin="4%,1%,1%,2%" \
                    --inline-info \
                    --preview 'xbps-query -S {2} '\
                    --preview-window=right:55%:wrap \
                    --header="Tasto TAB per (dis) selezionare. INVIO per eliminare. ESC per chiudere." \
                    --prompt="filter> " |
                awk '{print $2}'
            )"

            pkg="$( echo "$pkg" | paste -sd " " )"
            if [[ -n "$pkg" ]]
            then
            clear
            sudo xbps-pkgdb -m hold $pkg
            fi
}

function maintain
{
    sudo xbps-remove -Oo
    }

function ui
{
while true
do
clear
echo
    echo -e "                     \e[7m XbpsUI - Gestore di pacchetti \e[0m                 "
    echo -e "┌──────────────────────────────────────────────────────────────┐"
    echo -e "│ 1   \e[1mU\e[0m Aggiorna il Sistema          2   \e[1mM\e[0m Aggiorna Softwares  │"
    echo -e "│ 3   \e[1mI\e[0m Installa Pacchetti           4   \e[1mP\e[0m Rimuovi Pacchetti   │"
    echo -e "│ 5   \e[1mH\e[0m Mantieni Pacchetti           6   \e[1mU\e[0m Pacchetti Nascosti  │"
    echo -e "└──────────────────────────────────────────────────────────────┘"

    echo -e "  Inserisci il numero o la lettera contrassegnata  '0'  \e[1mQ\e[0muit "
    read -r choice
    choice="$(echo "$choice" | tr '[:upper:]' '[:lower:]' )"
    echo

    case "$choice" in
        1|u|update|update-system )
            update
            echo
            echo -e " \e[41m Sistema aggiornato. Per tornare a xbpsUI premere INVIO \e[0m"
            # attendere l'input, ad es. premendo INVIO:
            read
            ;;
        2|m|maintain|maintain-system )
            maintain
            echo
            echo -e " \e[41m Manutenzione del sistema completata. Per tornare a xbpsUI premere INVIO \e[0m"
            read
            ;;
        3|i|install|install-packages )
            install
            echo
            echo -e " \e[41m Installazione del pacchetto completata. Per tornare a xbpsUI premere INVIO \e[0m"
            read
            ;;
        4|p|purge|purge-packages )
            purge
            echo
            echo -e " \e[41m Pacchetto(i) eliminato(i). Per tornare a xbpsUI premere INVIO \e[0m"
            read
            ;;
        5|h|hold|hold-packages )
            hold
            echo
            echo -e " \e[41m pacchetto(i) tenuto. Per tornare a xbpsUI premere INVIO \e[0m"
            read
            ;;
         6|u|unhold|unhold-packages )
            unhold
            echo
            echo -e " \e[41m Pacchetto(i) nascosti. Per tornare a xbpsUI premere INVIO \e[0m"
            read
            ;;
        0|q|quit|$'\e'|$'\e'$'\e' )
        clear && exit
            ;;

            * )
            echo -e " \e[41m Opzione non valida \e[0m"
            echo -e "  Per favore riprova...  "
            sleep 2
            ;;

      esac
      done
    }

ui

