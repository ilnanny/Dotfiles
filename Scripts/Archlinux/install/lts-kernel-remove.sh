#!/bin/bash
#================================================
#================================================
#   O.S.      : Gnu Linux                       =
#   Author    : Cristian Pozzessere   = ilnanny =
#   D.A.Page  : http://ilnanny.deviantart.com   =
#   Github    : https://github.com/ilnanny      =
#================================================
#================================================

echo "Do not just run this. Examine and judge. Run at own risk."
echo
echo "Press enter to continue"; read dummy;

package="linux-lts"


#----------------------------------------------------------------------------------

#checking if application is already installed or else install with aur helpers
if pacman -Qi $package &> /dev/null; then



	#checking which helper is installed
	if pacman -Qi pacman &> /dev/null; then

		echo "Removing with pacman"
		sudo pacman -R --noconfirm $package

	fi

	# Just checking if uninstalling was successful
	if pacman -Qi $package &> /dev/null; then

	echo "################################################################"
	echo "#########  "$package" has NOT been uninstalled"
	echo "################################################################"

	else

	echo "################################################################"
	echo "#########  "$package" has been uninstalled"
	echo "################################################################"

	fi


else

	echo "################################################################"
	echo "######### "$package" is already uninstalled"
	echo "################################################################"

fi


package="linux-lts-headers"


#----------------------------------------------------------------------------------

#checking if application is already installed or else install with aur helpers
if pacman -Qi $package &> /dev/null; then



	#checking which helper is installed
	if pacman -Qi pacman &> /dev/null; then

		echo "Removing with pacman"
		sudo pacman -R --noconfirm $package

	fi

	# Just checking if uninstalling was successful
	if pacman -Qi $package &> /dev/null; then

	echo "################################################################"
	echo "#########  "$package" has NOT been uninstalled"
	echo "################################################################"

	else

	echo "################################################################"
	echo "#########  "$package" has been uninstalled"
	echo "################################################################"

	fi


else

	echo "################################################################"
	echo "######### "$package" is already uninstalled or was not present."
	echo "################################################################"

fi


sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "Now reboot"
