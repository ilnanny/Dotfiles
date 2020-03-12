#================================================
#   O.S.      : Gnu Linux                       =
#   Author    : Cristian Pozzessere   = ilnanny =
#   D.A.Page  : http://ilnanny.deviantart.com   =
#   Github    : https://github.com/ilnanny      =
#================================================
# File di configurazione globale di  Bash Shell
# I file di configurazione per le varie distro
# sono collocate in /etc/bash
#================================================

# ____________________________  Shell Interattiva
case $- in
    *i*) ;;
      *) return;;
esac

# ____________________________  Profili
for SH in /etc/profile.d/*.sh; do
       . $SH
done

# ____________________________  Alias
for sh in /etc/bash/bashrc.d/* ; do
	[[ -r ${sh} ]] && source "${sh}"
done

if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi

# ____________________________  Fine
