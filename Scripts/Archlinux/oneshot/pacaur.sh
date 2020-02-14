#! /bin/sh
#================================================
#================================================
#   O.S.      : Gnu Linux                       =
#   Author    : Cristian Pozzessere   = ilnanny =
#   D.A.Page  : http://ilnanny.deviantart.com   =
#   Github    : https://github.com/ilnanny      =
#================================================
#================================================
	# Install Cower (Pacaur dependency)
	git clone https://aur.archlinux.org/cower.git
	cd cower
	makepkg -si
	cd ..
	
	# Install Pacaur
	git clone https://aur.archlinux.org/pacaur.git
	cd pacaur
	makepkg -si
	cd ..
