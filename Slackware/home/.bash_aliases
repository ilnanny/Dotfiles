#!/bin/bash
#================================================
#================================================
#   O.S.      : Gnu Linux                       =
#   Author    : Cristian Pozzessere   = ilnanny =
#   D.A.Page  : http://ilnanny.deviantart.com   =
#   Github    : https://github.com/ilnanny      =
#================================================
#================================================

# ___      Alias Principali


alias 300dpi="for i in *; do inkscape $i -d=300 -C --export-png=`echo $i | sed -e s/svg$/png/`; done"
alias 7zip='7za a -t7z -mx=9 -mfb=256 -md=256m -ms=on'
alias bashome="geany ~/.bashrc"
alias adb="sudo adb"
alias blkid='sudo blkid -c /dev/null -o list'
alias chgrp='chgrp --preserve-root'
alias chown='chown --preserve-root'
alias cp="cp -v"
alias df='df -h'
alias egrep='egrep --color=auto'
alias emoji='cat /home/ilnanny/bin/ascii-emoji'
alias eps2svg='for i in *; do inkscape $i --export-plain-svg=`echo $i | sed -e s/eps$/svg/`; done'
alias fc='sudo fc-cache -fv'
alias fgrep='fgrep --color=auto'
alias fixpng="find . -type f -name "*.png" -exec convert {} -strip {} \;"
alias free="free -mt"
alias grep="grep -i --color=auto"
alias gruppi="cut -d: -f1 /etc/group"
alias gy='sudo geany'
alias hw="hwinfo --short"
alias info='info --vi-keys --init-file=${XDG_CONFIG_HOME}/infokey'
alias inxi='sudo inxi -xrmFA'
alias kc='killall conky'
alias l="ls -la --dereference-command-line-symlink-to-dir"
alias ll="ls --dereference-command-line-symlink-to-dir -lh"
alias ll='ls -la'
alias ln="ln -v"
alias lp='sudo leafpad'
alias ls="ls --group-directories-first --dereference-command-line-symlink-to-dir --color=auto"
alias lsx='sudo lshw -X'
alias lsbk='lsblk -o +fstype,label,uuid,partuuid'
alias meteo='curl wttr.in/Taranto'
alias microcode='grep . /sys/devices/system/cpu/vulnerabilities/*'
alias mp='sudo mousepad'
alias mv="mv -v"
alias myscript='geany /home/ilnanny/bin/zz-ilnanny'
alias nn='sudo nano'
alias pgrep="pgrep -l"
alias ping='ping -c www.google.com'
alias pipinstall='pip install --user'
alias ps="ps auxf"
alias reboot='sudo reboot'
alias riavvia='sudo reboot'
alias rm="rm -v"
alias spegni='sudo shutdown -r now'
alias svg2png='for i in *; do inkscape $i --export-png=`echo $i | sed -e 's/svg$/png/'`; done'
alias upgrub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias utenti="cut -d: -f1 /etc/passwd"
alias vbm="sudo mount -t vboxsf -o rw,uid=1000,gid=1000 Public /home/$USER/Pubblici"
alias youtube-mp3='youtube-dl --extract-audio --audio-format mp3  --audio-quality 0'
alias youtube-video="youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best'"


# ___      Alias Directorys


alias ath='su -c "zcat /proc/config.gz | grep CONFIG_ATH"'
alias backup='sh /home/ilnanny/bin/backup'
alias blb='sh /home/ilnanny/bin/bleachbit1'
alias cleaner='sh /home/ilnanny/bin/cleaner'
alias clone='cd ~/Git && git clone'
alias fstab='sudo geany /etc/fstab'
alias gitup='sh /home/ilnanny/bin/gitup'
alias goapp='sudo thunar /usr/share/applications/'
alias goicon='sudo thunar /usr/share/icons/'
alias goportage='sudo thunar /etc/portage/'
alias gotheme='sudo thunar /usr/share/themes/'
alias goscript='sudo thunar /home/ilnanny/bin/'
alias gowall='sudo thunar /usr/share/backgrounds/'
alias godotfiles='thunar /media/Dati/Git/Dotfiles/'
alias gogit='thunar /media/Dati/Git/'
alias gowiki='thunar /media/Dati/Git/Dotfile/01-Files/Wiki-Memo-txt/Gentoo/'
alias mioscript='geany /media/Dati/Git/Dotfile/Scripts/zz-ilnanny'
alias memousb='sh /home/ilnanny/bin/usblist'
alias myip=' sudo wget -qO- http://ipecho.net/plain'
alias showalias='cat /etc/bash/bashrc.d/alias.sh'
alias usblist='su -c "sh /home/ilnanny/bin/usblist"'
alias wiki="cd /media/Dati/Git/Dotfiles/01-Files/Wiki/Gentoo-wiki && whereis"

# ___      Alias Slackware


alias explode='sudo explodepkg'
alias getclean='sudo slapt-get --autoclean && sudo slapt-get --clean'
alias getin='sudo slapt-get -i'
alias getr='sudo slapt-get -remove'
alias getsearch='sudo slapt-get --search'
alias getup='sudo slapt-get -u'
alias getupgrade='sudo slapt-get --upgrade'
alias goslapt-get='sudo thunar /etc/slapt-get/'
alias ipk='sudo pkg -i'
alias ipkg='sudo installpkg'
alias makepkg='sudo makepkg'
alias rpk='sudo pkg -r'
alias rpkg='sudo removepkg'
alias slackinstall=' sudo slackpkg install'
alias slacksearch=' sudo slackpkg search'
alias slackupdate='sudo slackpkg update'
alias slackupgrade='sudo slackpkg upgrade-all'
alias slapt-getrc='sudo geany /etc/slapt-get /slapt-getrc'


# ___        Alias Gentoo


# alias ask='sudo emerge --ask'
# alias aut='sudo emerge --autounmask-write'
# alias backup="tar -cjpP --ignore-failed-read --exclude=/home/*/.bash_history --exclude=/dev/* --exclude=/media/* --exclude=/mnt/*/* --exclude=/proc/* --exclude=/run/* --exclude=/sys/* --exclude=/tmp/* --exclude=/usr/portage/* --exclude=/var/lock/* --exclude=/var/log/* --exclude=/var/run/* --exclude=media/Dati/backup1.tar.bz2 -f /media/Dati/backup_genbox.tar.bz2 /*"
# alias dup='sudo emerge -Dup world'
# alias emc='sudo emerge -C'
# alias emdc='sudo emerge --depclean --ask'
# alias emp='sudo emerge -pv'
# alias ems='sudo emerge -S'
# alias emun='sudo emerge --unmerge'
# alias emus='sudo emerge -uDN system'
# alias emuw='sudo emerge -uDN world'
# alias empr='sudo emerge @preserved-rebuild'
# alias et='sudo etc-update'
# alias eup='sudo env-update && source /etc/profile'
# alias evp='emerge -evp --deep world'
# alias fsync='sudo ego sync'
# alias install='sudo emerge'
# alias lay='sudo layman -S'
# alias lop='sudo genlop -c'
# alias mconf='sudo geany /etc/portage/make.conf'
# alias nodeps='sudo emerge --nodeps'
# alias noreplace='sudo emerge --noreplace'
# alias oneshot='sudo emerge --oneshot'
# alias pak='sudo geany /etc/portage/package.accept_keywords'
# alias pk='sudo geany /etc/portage/package.keywords'
# alias pm='sudo geany /etc/portage/package.mask'
# alias pu='sudo geany /etc/portage/package.use'
# alias rdr='sudo revdep-rebuild -iq'
# alias search='sudo emerge --search'
# alias sync='sudo emerge --sync'
# alias update='sudo emerge --update --nospinner --noreplace world'
# alias upgrade='su -c "emerge --update --deep --with-bdeps=y --newuse --autounmask-write world ||etc-update"'
# alias vs='sudo emerge -vs'
# alias world='sudo geany /var/lib/portage/world'


# ___        Alias Devuan


# alias ipk='sudo dpkg -i'
# alias rpk='sudo dpkg -r'
# alias install='sudo apt install'
# alias instally='sudo apt install -y'
# alias upgrade='sudo apt dist-upgrade'
# alias update='sudo apt update && sudo apt upgrade'
# alias autoremove='sudo apt autoremove'
# alias remove='sudo apt remove  && sudo apt purge && sudo apt autoremove'
# alias apt='sudo apt'
# alias sourcelist='sudo geany /etc/apt/sources.list'
# alias sourcelistd='gksudo thunar /etc/apt/sources.list.d/'


# ___        Alias Void


# alias sv="sudo sv"
# alias lvs="sudo lvs"
# alias vgs="sudo vgs"
# alias vgdisplay="sudo vgdisplay"
# alias install="sudo xbps-install"
# alias query="sudo xbps-query"
# alias remove="sudo xbps-remove -R"
# alias pkgdb="sudo xbps-pkgdb"
# alias reconfigure="sudo xbps-reconfigure"
# alias update="sudo xbps-install -Su"
# alias search="sudo xbps-query -Rs"
# alias ccache="xbps-remove -O"

#
# ___        Alias Archlinux


# alias pacman='sudo pacman --color auto'
# alias update='sudo pacman -Syyu'
# alias install='sudo pacman -S'
# alias remove='sudo pacman -R'
# alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'
# alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
# alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -100"
# alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'
# alias unlock="sudo rm /var/lib/pacman/db.lck"
# alias pksyua="yay -Syu --noconfirm"
# alias pksyua="yay -Syu --noconfirm"
