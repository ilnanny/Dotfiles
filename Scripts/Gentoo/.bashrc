# = = = = = = = = = = = = = = = = =  B A S H R C  = = = = = = = = = = = = = = = = #
# =
case $- in
    *i*) ;;
      *) return;;
esac
# =
HISTCONTROL=ignoreboth
# =
shopt -s histappend
# =
HISTSIZE=1000
HISTFILESIZE=2000
# =
shopt -s checkwinsize
# =
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
# = 
if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi
# = 
for SH in /etc/profile.d/*.sh; do
       . $SH
done
# = 
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac
# =
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac
# =
red='\[\e[0;31m\]'
RED='\[\e[1;31m\]'
blue='\[\e[0;34m\]'
BLUE='\[\e[1;34m\]'
cyan='\[\e[0;36m\]'
CYAN='\[\e[1;36m\]'
green='\[\e[0;32m\]'
GREEN='\[\e[1;32m\]'
yellow='\[\e[0;33m\]'
YELLOW='\[\e[1;33m\]'
PURPLE='\[\e[1;35m\]'
purple='\[\e[0;35m\]'
nc='\[\e[0m\]'

if [ "$UID" = 0 ]; then
    PS1="$red\u$nc@$red\H$nc:$CYAN\w$nc\\n$red#$nc "
else
    PS1="$PURPLE\u$nc@$CYAN\H$nc:$GREEN\w$nc\\n$GREEN\$$nc "
fi
# = 
#ListAllCommands | grep searchstr
function ListAllCommands
{
    COMMANDS=`echo -n $PATH | xargs -d : -I {} find {} -maxdepth 1 \
        -executable -type f -printf '%P\n'`
    ALIASES=`alias | cut -d '=' -f 1`
    echo "$COMMANDS"$'\n'"$ALIASES" | sort -u
}

# = 
# =  =
export LANG=it_IT.UTF-8
export LANGUAGE=it_IT.UTF-8
export LC_TYPE=it_IT.UTF-8
export XDG_CONFIG_HOME="/home/ilnanny/.config"
export GTK2_RC_FILES=$HOME/.gtkrc-2.0
export EDITOR=nano
export TERM=xterm
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/lib/pkgconfig
export GPG_TTY=$(tty)
export BROWSER=firefox 

# = = = = = = = = = = = = = = = = = = =  A L I A S   = = = = = = = = = = = = = = = = = = = #

alias 7zip='7za a -t7z -mx=9 -mfb=256 -md=256m -ms=on'
alias adb="sudo adb"
alias allcommands='ListAllCommands' 
alias blkid='sudo blkid -c /dev/null -o list'
alias chgrp='chgrp --preserve-root'
alias chmod='chmod --preserve-root'
alias chown='chown --preserve-root'
alias cp="cp -v"
alias egrep='egrep --color=auto'
alias egrep="egrep --color=auto"
alias emoji='cat /home/ilnanny/Scripts/ascii-emoji'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias grep="grep -i --color=auto"
alias gy='sudo geany' 
alias info='info --vi-keys --init-file=${XDG_CONFIG_HOME}/infokey'
alias inxi='sudo inxi -xrmFA'
alias ll="ls --dereference-command-line-symlink-to-dir -lh"
alias ll='ls -la'
alias l="ls -la --dereference-command-line-symlink-to-dir"
alias ln="ln -v"
alias lp='sudo leafpad'
alias lsbk='lsblk -o +fstype,label,uuid,partuuid'
alias ls='ls --color=auto'
alias ls="ls --group-directories-first --dereference-command-line-symlink-to-dir --color=auto"
alias mp='sudo mousepad' 
alias mv="mv -v"
alias nn='sudo nano'
alias pgrep="pgrep -l"
alias ping='ping -c www.google.com'
alias pl='sudo pluma'
alias reboot='sudo reboot'
alias riavvia='sudo reboot'
alias rm="rm -v"
alias spegni='sudo shutdown -r now'
alias upgrub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias youtube-mp3='youtube-dl --extract-audio --audio-format mp3  --audio-quality 0'
alias youtube-video="youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best'"
alias svg2png='for i in *; do inkscape $i --export-png=`echo $i | sed -e 's/svg$/png/'`; done'
alias eps2svg='for i in *; do inkscape $i --export-plain-svg=`echo $i | sed -e s/eps$/svg/`; done'

# = DIR.
alias ath='su -c "zcat /proc/config.gz | grep CONFIG_ATH"'
alias backup='sh /home/ilnanny/Scripts/backup'
alias blb='sh /home/ilnanny/Scripts/bleachbit1'
alias cleaner='sh /home/ilnanny/Scripts/cleaner'
alias clone='cd ~/Git && git clone'
alias fstab='sudo geany /etc/fstab'
alias gitup='sh /home/ilnanny/Scripts/gitup'
alias goapp='sudo thunar /usr/share/applications/'
alias goicon='sudo thunar /usr/share/icons/'
alias goportage='sudo thunar /etc/portage/'
alias goscript='sudo thunar /home/ilnanny/Scripts/'
alias gowall='sudo thunar /usr/share/backgrounds/'
alias godotfiles='thunar /media/Dati/Dotfile/'
alias gogit='thunar /media/Dati/Git/'
alias gowiki='thunar /media/Dati/Git/Dotfile/01-Files/Wiki-Memo-txt/Gentoo/'
alias memousb='sh /home/ilnanny/Scripts/usblist'
alias myip=' sudo wget -qO- http://ipecho.net/plain'
alias themes='sudo thunar /usr/share/themes/'
alias usblist='su -c "sh /home/ilnanny/Scripts/usblist"'
# = Gentoo
alias ask='sudo emerge --ask'
alias aut='sudo emerge --autounmask-write'
alias dup='sudo emerge -Dup world'
alias emc='sudo emerge -C'
alias emdc='sudo emerge --depclean --ask'
alias emerge='sudo emerge'
alias emp='sudo emerge -pv'
alias empv='sudo emerge -pv'
alias ems='sudo emerge -S'
alias emun='sudo emerge --unmerge'
alias emus='sudo emerge -uDN system'
alias emuw='sudo emerge -uDN world'
alias epr='sudo emerge @preserved-rebuild'
alias eqa='equery a'
alias eqb='equery b'
alias eqc='equery c'
alias eqd='equery d'
alias eqf='equery f'
alias eqg='equery g'
alias eqh='equery h'
alias eqk='equery k'
alias eql='equery l'
alias eqm='equery m'
alias eqs='equery s'
alias equ='equery u'
alias eqw='equery w'
alias eqy='equery y'
alias et='sudo etc-update'
alias eup='sudo env-update && source /etc/profile'
alias evp='emerge -evp --deep world'
alias lay='sudo layman -S'
alias lop='sudo genlop -c'
alias mc='sudo geany /etc/portage/make.conf'
alias nodeps='sudo emerge --nodeps'
alias noreplace='sudo emerge --noreplace'
alias oneshot='sudo emerge --oneshot'
alias pak='sudo geany /etc/portage/package.accept_keywords'
alias pk='sudo geany /etc/portage/package.keywords'
alias pm='sudo geany /etc/portage/package.mask'
alias pu='sudo geany /etc/portage/package.use'
alias rdr='sudo revdep-rebuild -iq'
alias sync='sudo emerge --sync'
alias update='sudo emerge --update --nospinner --noreplace world'
alias upgrade='su -c "emerge --update --deep --with-bdeps=y --newuse --autounmask-write world ||etc-update"'
alias vs='sudo emerge -vs'
alias world='sudo geany /var/lib/portage/world'
#-= Backup 
alias genbk='sh /home/ilnanny/Scripts/gentoobackup'
alias etcbk='sudo cp -r -a /etc  /media/Dati/Linux/Configurazioni/Gentoo/'
alias rootbk='sudo cp -r -a /root  /media/Dati/Linux/Configurazioni/Gentoo/'
alias bootbk='sudo cp -r -a /boot  /media/Dati/Linux/Configurazioni/Gentoo/'
alias homebk='sudo cp -r -a /home/ilnanny  /media/Dati/Linux/Configurazioni/Gentoo/'
alias worldbk='sudo cp -r -a /var/lib/portage  /media/Dati/Linux/Configurazioni/Gentoo/Var-lib-portage/'

# = Slack
# alias ipkg='sudo installpkg'
# alias rpkg='sudo removepkg'
# alias explode='sudo explodepkg'
# alias makepkg='sudo makepkg'
# alias rpk='sudo pkg -r'
# alias ipk='sudo pkg -i'
# alias rpk='sudo pkg -r'
# alias install='sudo slapt-get -i'
# alias update='sudo slapt-get -u'
# alias slapt-get='sudo slapt-get '
# alias slapt-getrc='sudo geany /etc/slapt-get /slapt-getrc'
# alias goslapt-get='sudo thunar /etc/slapt-get/'
# alias slacbk='sh /home/ilnanny/Scripts/slackbackup'
# alias etcbk='sudo cp -r -a /etc  /media/dati/Linux/Configurazioni/Slackware/'
# alias rootbk='sudo cp -r -a /root  /media/dati/Linux/Configurazioni/Slackware/'
# alias bootbk='sudo cp -r -a /boot  /media/dati/Linux/Configurazioni/Slackware/Boot'
# alias homebk='sudo cp -r -a /home/ilnanny  /media/dati/Linux/Configurazioni/Slackware/'

# = Devuan
#alias ipk='sudo dpkg -i'
#alias rpk='sudo dpkg -r'
#alias install='sudo apt install'
#alias instally='sudo apt install -y'
#alias upgrade='sudo apt dist-upgrade'
#alias update='sudo apt update && sudo apt upgrade'
#alias autoremove='sudo apt autoremove'
#alias remove='sudo apt remove  && sudo apt purge && sudo apt autoremove' 
#alias apt='sudo apt'
#alias sourcelist='sudo geany /etc/apt/sources.list'
#alias sourcelistd='sudo thunar /etc/apt/sources.list.d/'
#alias debianbk='sh /home/ilnanny/Scripts/slackbackup'
#alias etcbk='sudo cp -r -a /etc  /media/dati/Linux/Configurazioni/Debian/'
#alias rootbk='sudo cp -r -a /root  /media/dati/Linux/Configurazioni/Debian/'
#alias bootbk='sudo cp -r -a /boot  /media/dati/Linux/Configurazioni/Debian/Boot'
#alias homebk='sudo cp -r -a /home/ilnanny  /media/dati/Linux/Configurazioni/Debian/'

# = VOID
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
# alias etcbk='sudo cp -r -a /etc  /media/Dati/Linux/Configurazioni/Void/'
# alias rootbk='sudo cp -r -a /root  /media/Dati/Linux/Configurazioni/Void/'
# alias bootbk='sudo cp -r -a /boot  /media/Dati/Linux/Configurazioni/Void/Boot'
# alias homebk='sudo cp -r -a /home/ilnanny  /media/Dati/Linux/Configurazioni/Void/'
#
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
