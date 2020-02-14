# Offline Notes

I tend to do a lot of offline testing of Gentoo installs, and rebuilding local
VMs where it would be useful (and kind to the mirrors) to keep the relevant
distfiles and ebuilds on the local network.

Tipes from the Gentoo forums:

* Don't use the default locations of /usr/portage/distfiles and
  /usr/portage/packages (change in /etc/make.conf)
* `emerge -fp <target>` will download any required external files to the
  distfiles directory, seems like I may want to do this: `emerge -uDNpfv --with-bdeps=y @world`

References:

* https://forums.gentoo.org/viewtopic-p-3461249.html
* https://wiki.gentoo.org/wiki/Local_distfiles_cache
* http://swift.siphos.be/aglara/aglara.pdf
