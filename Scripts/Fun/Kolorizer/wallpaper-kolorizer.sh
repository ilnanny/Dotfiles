#!/bin/bash
# Change wallpapers color

readonly BlendColor="7952B3"

### Some colors
## Material Design palette -> https://material.io/guidelines/style/color.html#color-color-palette
## Fluent Design palette -> https://docs.microsoft.com/en-us/windows/uwp/design/style/color#accent-color
## Arch blue = 1793D1
## Crunchbang dark = 2E3436
## Crunchbang light = BFBFBF
## Debian red = D70A53
## Fedora blue = 3C6EB4
## Gentoo purple = 54487A
## openSUSE lightgreen = 73BA25
## openSUSE darkgreen = 6DA741
## openSUSE lightcyan = 35B9AB
## openSUSE darkcyan = 00A489
## Pop OS brown = 574F4A
## Pop OS cyan = 48B9C7
## Pop OS yellow = FAA41A
## RedHat mediumred = A30000
## RedHat lightblue = A3DBE8
## RedHat darkblue = 004153
## SteamOS green = 5C7E10
## SteamOS bluedark = 252C3F
## SteamOS bluelight = 6699FF
## SUSE green = 02D35F
## Ubuntu orange = EB6536
## Ubuntu purple = 84377D
## Ubuntu Budgie blue = 4D90D6
## Ubuntu Budgie red = A34F6D
## Ubuntu Budgie slate = 383C4A
## Ubuntu MATE green = 87A556
## Ubuntu MATE red = DD4814
## GNOME Adwaita beige = C6AF90
## GNOME Adwaita blue = 4A90D9
## KDE Plasma blue = 3DAEE9
## Windows select blue = CDE4FC
## Windows folder yellow = FFE79B
## MiamiVice bluegreen = 0BD3D3
## MiamiVice pink = F890E7
## Apple website blue = 0070C9
## Apple website green = 47B04B
## Apple website grey = 888888
## Apple website orange = E85D00
## Apple website red = CF102D
## Bondi Blue = 0095B6
## Bootstrap purple = 7952B3
## Bootstrap yellow = FFE484
## Bootstrap grey = 6C757D
## Bulma green = 00D1B2
## Lamborghini gold = DDB321
## Mozilla MDN blue = 3F87A6
## Mozilla MDN grey = 9B9B9B
## Mozilla MDN red = E66465
## Mozilla MDN yellow = F6B73C
## OnePlus red = EB0029
## VALVe brown = 745E4E
## VALVe green = D3D6CA
## VALVe orange = CF381E
## Pantone rose quartz = F7CAC9
## Pantone serenity = 92A8D1
## Sherwin taupe = 8C7E78
## Gunmetal = 2C3539
## Graphite = 577287
## DarthWound red = A63F3F
## Papirus black = 505050
## Papirus grey = 8D8D8D
## Papirus brown = AE8D6E
## Papirus green = 84B05F
## Papirus teal = 009F85
## Papirus cyan = 00BAD2
## Papirus blue = 4F92DE

cd $(xdg-user-dir PICTURES)
rm wp-*
wget https://raw.githubusercontent.com/DarthWound/wallpaper-kolorizer/master/wps/wp-abrashy.svg
wget https://raw.githubusercontent.com/DarthWound/wallpaper-kolorizer/master/wps/wp-angly.svg
wget https://raw.githubusercontent.com/DarthWound/wallpaper-kolorizer/master/wps/wp-angly3D.svg
wget https://raw.githubusercontent.com/DarthWound/wallpaper-kolorizer/master/wps/wp-aqueousy.svg
wget https://raw.githubusercontent.com/DarthWound/wallpaper-kolorizer/master/wps/wp-carbony.svg
wget https://raw.githubusercontent.com/DarthWound/wallpaper-kolorizer/master/wps/wp-crossy.svg
wget https://raw.githubusercontent.com/DarthWound/wallpaper-kolorizer/master/wps/wp-foxy.svg
wget https://raw.githubusercontent.com/DarthWound/wallpaper-kolorizer/master/wps/wp-gradienty.svg
wget https://raw.githubusercontent.com/DarthWound/wallpaper-kolorizer/master/wps/wp-irongripy.svg
wget https://raw.githubusercontent.com/DarthWound/wallpaper-kolorizer/master/wps/wp-lineny.svg
wget https://raw.githubusercontent.com/DarthWound/wallpaper-kolorizer/master/wps/wp-materialy1.svg
wget https://raw.githubusercontent.com/DarthWound/wallpaper-kolorizer/master/wps/wp-materialy2.svg
wget https://raw.githubusercontent.com/DarthWound/wallpaper-kolorizer/master/wps/wp-noisy.svg
wget https://raw.githubusercontent.com/DarthWound/wallpaper-kolorizer/master/wps/wp-printy.svg
wget https://raw.githubusercontent.com/DarthWound/wallpaper-kolorizer/master/wps/wp-smoky.svg
wget https://raw.githubusercontent.com/DarthWound/wallpaper-kolorizer/master/wps/wp-tweedy.svg
wget https://raw.githubusercontent.com/DarthWound/wallpaper-kolorizer/master/wps/wp-variety.svg
wget https://raw.githubusercontent.com/DarthWound/wallpaper-kolorizer/master/wps/wp-vivaldy.svg

sleep 2s

sed -i "s/7952B3/$BlendColor/gI" wp-*.svg

sleep 2s

for file in wp-*.svg; do inkscape -z $file -e ${file%svg}png -w 3840 -h 2160; done

sleep 2s

rm wp-*.svg

clear
printf "Kolorized! You can change your background now.\nIf your desktop does not support SVG wallpapers then convert to PNG.\n"
read -p "Press ENTER to close."
