#  ------------------------------------------   >     Shell Interattiva
case $- in
    *i*) ;;
      *) return;;
esac
#  ------------------------------------------   >     Aliases Utente
if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi
#  ------------------------------------------   >     Aliases Globali '.sh'
for sh in /etc/bash/bashrc.d/* ; do
	[[ -r ${sh} ]] && source "${sh}"
done
#  ------------------------------------------   >     Profili
for SH in /etc/profile.d/*.sh; do
       . $SH
done