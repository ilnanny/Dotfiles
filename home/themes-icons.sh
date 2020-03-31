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

cp -a -r /media/Dati/Git/XThemes/GTK-themes/Noktomix /usr/share/themes/
cp -a -r /media/Dati/Git/XThemes/GTK-themes/Celedark /usr/share/themes/
cp -a -r /media/Dati/Git/XThemes/GTK-themes/Classico /usr/share/themes/
cp -a -r /media/Dati/Git/XThemes/GTK-themes/Crynge /usr/share/themes/
cp -a -r /media/Dati/Git/XThemes/GTK-themes/Grigio /usr/share/themes/
cp -a -r /media/Dati/Git/XThemes/GTK-themes/Larry-Dark /usr/share/themes/
cp -a -r /media/Dati/Git/XThemes/GTK-themes/Larrycow /usr/share/themes/
cp -a -r /media/Dati/Git/XThemes/GTK-themes/Lila-Gtk /usr/share/themes/
cp -a -r /media/Dati/Git/XThemes/GTK-themes/Mybrown /usr/share/themes/
cp -a -r /media/Dati/Git/XThemes/GTK-themes/Newclear /usr/share/themes/
cp -a -r /media/Dati/Git/XThemes/GTK-themes/Nocciola /usr/share/themes/
cp -a -r /media/Dati/Git/XThemes/GTK-themes/Stonex /usr/share/themes/
cp -a -r /media/Dati/Git/XThemes/GTK-themes/Teiera /usr/share/themes/

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
echo " Temi Gtk Icone e Cursori sono stati installati,
                Puoi chiudere il terminale "
sleep 2
exit 0
