#!/bin/bash
#================================================
#================================================
#   O.S.      : Gnu Linux                       =
#   Author    : Cristian Pozzessere   = ilnanny =
#   D.A.Page  : http://ilnanny.deviantart.com   =
#   Github    : https://github.com/ilnanny      =
#================================================
#   Project:    GTK Themes                      =
#================================================
set -o errexit
[[ $(whoami) == 'root' ]] || exec sudo su -c $0 root

echo " Installo i themi gtk nella cartella /usr/share/themes"
echo " Devi avere installato x11-themes/gtk-engines-murrine"
sleep 2
cp -a -r  ../GTK-themes/Noktomix /usr/share/themes/
cp -a -r  ../GTK-themes/Celedark /usr/share/themes/
cp -a -r  ../GTK-themes/Classico /usr/share/themes/
cp -a -r  ../GTK-themes/Crynge /usr/share/themes/
cp -a -r  ../GTK-themes/Grigio /usr/share/themes/
cp -a -r  ../GTK-themes/Larry-Dark /usr/share/themes/
cp -a -r  ../GTK-themes/Larrycow /usr/share/themes/
cp -a -r  ../GTK-themes/Lila-Gtk /usr/share/themes/
cp -a -r  ../GTK-themes/Mybrown /usr/share/themes/
cp -a -r  ../GTK-themes/Newclear /usr/share/themes/
cp -a -r  ../GTK-themes/Nocciola /usr/share/themes/
cp -a -r  ../GTK-themes/Stonex /usr/share/themes/
cp -a -r  ../GTK-themes/Teiera /usr/share/themes/
cp -a -r  ../GTK-themes/Nordic-bluish-accent-standard-buttons /usr/share/themes/
cp -a -r  ../GTK-themes/Nordic-Polar-standard-buttons /usr/share/themes/
cp -a -r  ../GTK-themes/Nordic-standard-buttons /usr/share/themes/

echo " Installo i themi di icone nella cartella /usr/share/icons"
sleep 2

cp -a -r /media/Dati/Git/Blender-icon-theme/Blender /usr/share/icons/
cp -a -r /media/Dati/Git/Blender-icon-theme/blender-blue/ /usr/share/icons/
cp -a -r /media/Dati/Git/Blender-icon-theme/blender-cyan/ /usr/share/icons/
cp -a -r /media/Dati/Git/Blender-icon-theme/blender-dark/ /usr/share/icons/
cp -a -r /media/Dati/Git/Blender-icon-theme/blender-dkblue/ /usr/share/icons/
cp -a -r /media/Dati/Git/Blender-icon-theme/blender-kaki/ /usr/share/icons/
cp -a -r /media/Dati/Git/Blender-icon-theme/blender-red/ /usr/share/icons/
#
cp -a -r /media/Dati/Git/Blender-icon-theme/Lila_HD-cursor/ /usr/share/icons/
#
sh /usr/share/icons/Blender/icon-cache-maker.sh
#
echo " Cambio la cartella degli sfondi con quella personale"
mv /usr/share/backgrounds/xfce /usr/share/backgrounds/xfce.bk
ln -s /media/Dati/Git/backgrounds/backgrounds/ /usr/share/backgrounds/xfce
sleep 2

echo " Temi Gtk Icone e Cursori  e Wallpapers sono stati installati,
                Puoi chiudere il terminale "
sleep 2
exit 0
