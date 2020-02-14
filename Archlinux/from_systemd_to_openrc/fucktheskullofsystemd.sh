:

echo Starting operation FUCKTHESKULLOFSYSTEMD

[[ $1 == openrc ]] && target=openrc
[[ $1 == runit ]] && target=runit

# runit not yet implemented
#[[ $target ]] || { echo "Usage: $0 <openrc|runit>" ; exit 1; }
#echo "Target: $target"

rm -f /var/lib/pacman/db.lck
# A full systemd update is needed, because libsystemd->systemd-libs
pacman -Syu --noconfirm
pacman -S --needed --noconfirm wget

cd /etc
mv -vf pacman.conf pacman.conf.arch
wget https://gitea.artixlinux.org/packagesP/pacman/raw/branch/master/trunk/pacman.conf -O /etc/pacman.conf
mv -vf pacman.d/mirrorlist pacman.d/mirrorlist-arch
wget https://gitea.artixlinux.org/packagesA/artix-mirrorlist/raw/branch/master/trunk/mirrorlist -O pacman.d/mirrorlist
cp -vf pacman.d/mirrorlist pacman.d/mirrorlist.artix

sed -i 's/Required DatabaseOptional/Never/' pacman.conf

pacman -Syy --noconfirm
echo "Answer <yes> to the next question to make sure all packages come from Artix repos"
read
pacman -Scc

pacman -S --noconfirm artix-keyring
pacman-key --populate artix
pacman-key --lsign-key 95AEC5D0C1E294FC9F82B253573A673A53C01BC2

systemctl list-units --state=running | grep -v systemd | awk '{print $1}' | grep service > /root/daemon.list
echo "Your systemd running units are saved in /root/daemon.list."
echo "Do not proceed if you've seen errors above - press CTRL-C to abort or ENTER to continue"
read

pacman -Sw --noconfirm base base-devel openrc-system grub linux-lts linux-lts-headers systemd-dummy systemd-libs-dummy openrc netifrc grub mkinitcpio
pacman -Rdd --noconfirm systemd systemd-libs systemd-sysvcompat pacman-mirrorlist
cp -vf pacman.d/mirrorlist.artix pacman.d/mirrorlist

pacman -S --noconfirm base base-devel openrc-system grub linux-lts linux-lts-headers systemd-dummy systemd-libs-dummy openrc netifrc grub mkinitcpio archlinux-mirrorlist net-tools rsync
pacman -S --noconfirm --needed at-openrc xinetd-openrc cronie-openrc haveged-openrc hdparm-openrc openssh-openrc syslog-ng-openrc

rc-update add haveged boot
rc-update add udev sysinit

for daemon in atd cronie sshd syslog-ng; do rc-update add $daemon; done

echo "Activating standard network interface naming (i.e. eth0)."
echo "If you prefer the persistent naming, remove the last line from /etc/default/grub"
read
echo 'GRUB_CMDLINE_LINUX="net.ifnames=0"' >>/etc/default/grub

pacman -S --needed --noconfirm netifrc
echo "============================"
echo "Write down you IP and route."
echo "============================"
ifconfig
route
echo "=============================================================="
echo "Press ENTER to edit conf.d/net to configure static networking."
echo "No editing is needed if you use dhcp or a network manager.    "
echo "=============================================================="
read
nano /etc/conf.d/net
ln -s /etc/init.d/net.lo /etc/init.d/net.eth0
rc-update add net.eth0 boot

for user in systemd-journal systemd-journal-gateway systemd-timesync systemd-network systemd-bus-proxy systemd-journal-remote systemd-journal-upload; do userdel $user; done

sed -i 's/= Never/= Required DatabaseOptional/' /etc/pacman.conf
sed -i 's/#rc_parallel="NO"/rc_parallel="YES"/' /etc/rc.conf
mkinitcpio -P
grub-mkconfig -o /boot/grub/grub.cfg

echo "==========================================="
echo "=     If you haven't seen any errors      =" 
echo "=          press ENTER to reboot          ="
echo "= Otherwise, switch console and fix them. ="
echo "==========================================="
read
sync
mount -f / -o remount,ro
echo s >| /proc/sysrq-trigger
echo u >| /proc/sysrq-trigger
echo b >| /proc/sysrq-trigger
