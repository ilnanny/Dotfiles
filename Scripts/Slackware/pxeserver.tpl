#!/bin/sh
#
# Copyright 2011, 2016, 2017, 2019  Eric Hameleers, Eindhoven, NL
# Copyright 2011  Patrick Volkerding, Sebeka, Minnesota USA
# All rights reserved.
#
# Redistribution and use of this script, with or without modification, is 
# permitted provided that the following conditions are met:
#
# 1. Redistributions of this script must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
#  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF 
#  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
#  EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
#  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
#  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
#  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
#  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
#  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF 
#  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Code used from SeTpxe and SeTnet scripts, part of the Slackware installer.
# ---------------------------------------------------------------------------

# PXEserver works as follows:
# - It requires a wired network; wireless PXE boot is impossible.
# - The pxeserver script tries to find a wired interface; you can pass an
#   explicit interfacename as parameter to the script (optional).
# - If multiple wired interfaces are detected, a dialog asks the user to
#   select the right one.
# - A check is done for DHCP configuration of this wired interface;
#   * If DHCP configuration is found then pxeserver will not start its own
#     DHCP server and instead will rely on your LAN's DHCP server.
#   * If no DHCP config is found, the script will ask permission to start
#     its own internal DHCP server.
#     Additionally the user will be prompted to configure an IP address for the
#     network interface and IP range properties for the internal DHCP server.
# - The script will then start the PXE server, comprising of:
#   * dnsmasq providing DNS, DHCP and BOOTP;
#   * NFS and RPC daemons;
# - The script will detect if you have an outside network connection on
#   another interface and will enable IP forwarding if needed, so that the
#   PXE clients will also have network access.
# - The Live OS booted via pxelinux is configured with additional boot
#   parameters:
#   * nfsroot=${LOCAL_IPADDR}:/mnt/livemedia
#   * luksvol=
#   * nop
#   * hostname=@DISTRO@
#   * tz=$(cat /etc/timezone)
#   * locale=${SYSLANG:-"en_US.UTF-8"}
#   * kbd=${KBD:-"us"}
#   Which shows that the configuration of the Live OS where the PXE server
#   runs is largely determining the configuration of the PXE clients.
# - Note that when networkbooting, the hostname of the Live OS will be
#   suffixed with the machine's MAC address to make every network-booted
#   Live OS unique.

#
# Initialization:
#

DEBUG=${DEBUG:-0}
DIALOG=dialog

# UEFI prefix:
UEFIPREFIX="/EFI/BOOT"

# Number of PXE clients we want to serve with our own DHCP server:
DEF_DHCP_RANGE=${DEF_DHCP_RANGE:-10}

# Optional argument to the script is the name of the interface on which
# the PXE server should run:
INTERFACE="$1"

# This variable will be used to determine if the network default gateway
# is reached through a second NIC in the computer, or not.
GLOBAL_GW_INT=""

# In the above case, the global and local gateways will not be equal.
GLOBAL_GATEWAY=""
LOCAL_GATEWAY=""

# The Slackware setup depends on english language settings because it
# parses program output like that of "fdisk -l". So, we need to override
# the Live user's local language settings here:
SYSLANG=$LANG
export LANG=C
export LC_ALL=C

# Warn the user if the Live Media is inaccessible (however unlikely):
if [ ! -d /mnt/livemedia/@LIVEMAIN@/system ]; then
  if [ $DEBUG -ne 0 ]; then read -p "Press ENTER to continue: " JUNK ; fi
  $DIALOG --title "LIVE MEDIA NOT ACCESSIBLE" --msgbox "\
\n\
Before you can install software, complete the following tasks:\n\
\n\
1. Mount your Live media partition on /mnt/livemedia." 16 68
  exit 1
fi

TMP=/var/log/setup/tmp
if [ ! -d $TMP ]; then
  mkdir -p $TMP
fi
rm -f $TMP/SeT* $TMP/pxe*
echo "on" > $TMP/SeTcolor # turn on color menus
PATH="$PATH:/usr/share/@LIVEMAIN@"
export PATH;
export COLOR=on

# Add some eye candy for BIOS PXE clients:
if [ -d /mnt/livemedia/boot/syslinux ]; then
  PXETXTSRC=/mnt/livemedia/boot/syslinux
elif [ -d /mnt/livemedia/boot/extlinux ]; then
  PXETXTSRC=/mnt/livemedia/boot/extlinux
else
  PXETXTSRC=""
fi
if [ -n "$PXETXTSRC" ]; then
  # All the files that are needed for the BIOS PXE boot menu:
  for SFILE in f2.txt f3.txt f4.txt message.txt swlogov.png ter-i16v.psf vesamenu.c32
  do
    ln -sf ${PXETXTSRC}/${SFILE} /var/lib/tftpboot/
  done
fi

# For UEFI computers:
mkdir -p  /var/lib/tftpboot${UEFIPREFIX}
ln -sf /mnt/livemedia${UEFIPREFIX}/@MARKER@  /var/lib/tftpboot${UEFIPREFIX}/
ln -sf /mnt/livemedia${UEFIPREFIX}/bootx64.efi  /var/lib/tftpboot${UEFIPREFIX}/
ln -sf /mnt/livemedia${UEFIPREFIX}/theme  /var/lib/tftpboot${UEFIPREFIX}/

#
# Function definitions:
#

# Function to convert the netmask from CIDR format to dot notation.
cidr_cvt() {
  # Number of args to shift, 255..255, first non-255 byte, zeroes
  set -- $(( 5 - ($1 / 8) )) 255 255 255 255 $(( (255 << (8 - ($1 % 8))) & 255 )) 0 0 0
  [ $1 -gt 1 ] && shift $1 || shift
  echo ${1-0}.${2-0}.${3-0}.${4-0}
}

# Function to convert the netmask from dot notation to CIDR format.
mask_cvt ()
{
  # Assumes there's no "255." after a non-255 byte in the mask
  local x=${1##*255.}
  set -- 0^^^128^192^224^240^248^252^254^ $(( (${#1} - ${#x})*2 )) ${x%%.*}
  x=${1%%$3*}
  echo $(( $2 + (${#x}/4) ))
}

# IP Address to integer conversion:
ip_to_int() {
  IFS=.
  set -f
  set -- $1
  echo $(($1 << 24 | $2 << 16 | $3 << 8 | $4))
}

# Integer to IP Address conversion:
int_to_ip() {
  echo $(($1>>24)).$(($1>>16&0xff)).$(($1>>8&0xff)).$(($1&0xff))
}

# Find the location of the dhcpcd PID file:
get_dhcpcd_pid() {
  # Find the location of the PID file of dhcpcd:
  MYDEV="$1"
  if [ -s /run/dhcpcd/dhcpcd-${MYDEV}.pid ]; then
    echo "/run/dhcpcd/dhcpcd-${MYDEV}.pid"
  elif [ -s /run/dhcpcd/dhcpcd-${MYDEV}-4.pid ]; then
    echo "/run/dhcpcd/dhcpcd-${MYDEV}-4.pid"
  elif [ -s /run/dhcpcd-${MYDEV}.pid ]; then
    echo "/run/dhcpcd-${MYDEV}.pid"
  elif [ -s /run/dhcpcd-${MYDEV}-4.pid ]; then
    echo "/run/dhcpcd-${MYDEV}-4.pid"
  else
    echo UNKNOWNLOC
  fi
}

# The network interface IP configuration routine.
# Will be called if the interface was not configured by DHCP.
# It ends with a configured network interface:
devconfig() {
  # Function accepts a parameter; if not given, use the global INTERFACE:
  MYIF=${1:-"$INTERFACE"}

  # Determine a LAN range we are going to be using for the internal DHCP
  # range that does not conflict with existing IP configuration:
  if ! ip -f inet -o addr show |grep -v " lo " |grep -qw 192.168 ; then
    MYIP="192.168.10.10"
  elif ! ip -f inet -o addr show |grep -v " lo " |grep -qw 172.16 ; then
    MYIP="172.16.10.10"
  else
    MYIP="10.10.10.10"
  fi

  # Main loop IP configuration:
  while [ 0 ]; do

    cat << EOF > $TMP/tempmsg

You will need to enter the IP address you wish to
assign to interface ${MYIF}. Example: ${MYIP}

What is your IP address?
EOF
    if [ "x$LOCAL_IPADDR" = "x" ]; then # assign default
      LOCAL_IPADDR=${MYIP}
    fi
    if [ $DEBUG -ne 0 ]; then read -p "Press ENTER to continue: " JUNK ; fi
    $DIALOG --title "ASSIGN IP ADDRESS" --inputbox "$(cat $TMP/tempmsg)" 12 \
      65 $LOCAL_IPADDR 2> $TMP/local
    if [ ! $? = 0 ]; then
      rm -f $TMP/tempmsg $TMP/local
      return
    fi
    LOCAL_IPADDR="$(cat $TMP/local)"
    rm -f $TMP/local
    clear
    cat << EOF > $TMP/tempmsg

Now we need to know your netmask.
Typically this will be 255.255.255.0
but this can be different depending on
your local setup.

What is your netmask?
EOF
    if [ "x$LOCAL_NETMASK" = "x" ]; then # assign default
      LOCAL_NETMASK=${NETMASK:-255.255.255.0}
    fi
    if [ $DEBUG -ne 0 ]; then read -p "Press ENTER to continue: " JUNK ; fi
    $DIALOG --title "ASSIGN NETMASK" --inputbox "$(cat $TMP/tempmsg)" 14 \
      65 $LOCAL_NETMASK 2> $TMP/mask
    if [ ! $? = 0 ]; then
      rm -f $TMP/tempmsg $TMP/mask
      return
    fi
    clear
    LOCAL_NETMASK="$(cat $TMP/mask)"
    rm $TMP/mask

    # GLOBAL_GATEWAY was determined right before calling this function:
    if [ "x$GLOBAL_GATEWAY" = "x" ]; then
      if [ $DEBUG -ne 0 ]; then read -p "Press ENTER to continue: " JUNK ; fi
      $DIALOG --yesno "Do you have a gateway?" 5 30
      HAVE_GATEWAY=$?
      clear
      if [ $HAVE_GATEWAY -eq 0 ]; then
        LOCAL_GATEWAY="$(echo $LOCAL_IPADDR | cut -f1-3 -d '.')."
        if [ $DEBUG -ne 0 ]; then read -p "Press ENTER to continue: " JUNK ; fi
        $DIALOG --title "ASSIGN GATEWAY ADDRESS" --inputbox \
          "\nWhat is the IP address for your gateway?" 9 65 \
          $LOCAL_GATEWAY 2> $TMP/gw
        if [ ! $? = 0 ]; then
          rm -f $TMP/tempmsg $TMP/gw
          LOCAL_GATEWAY=""
        else
          LOCAL_GATEWAY="$(cat $TMP/gw)"
          rm -f $TMP/gw
        fi
      fi
      unset HAVE_GATEWAY
      clear
    elif [ "$GLOBAL_GW_INT" = "$MYIF" ]; then
      LOCAL_GATEWAY=$GLOBAL_GATEWAY
    fi

    cat << EOF > $TMP/tempmsg

This is the proposed network configuration for $MYIF -
If this is OK, then select 'Yes'.
If this is not OK and you want to configure again, select 'No'.

* IP Address: $LOCAL_IPADDR 
* Netmask:    $LOCAL_NETMASK
* Gateway:    ${LOCAL_GATEWAY:-"$GLOBAL_GATEWAY (via $GLOBAL_GW_INT)"}
EOF
    if [ $DEBUG -ne 0 ]; then read -p "Press ENTER to continue: " JUNK ; fi
    $DIALOG --no-collapse --title "NETWORK CONFIGURATION" \
      --yesno "$(cat $TMP/tempmsg)" 14 68
    if [ $? -eq 1 ]; then
      continue # New round of questions
    fi

    #echo "Configuring ethernet card..."
    if [ $DEBUG -ne 0 ]; then read -p "Press ENTER to continue: " JUNK ; fi
    $DIALOG --title "INITIALIZING NETWORK" --infobox \
      "\nConfiguring your network interface $MYIF ..." 5 56

    # We don't need this anymore:
    dhcpcd -k $MYIF 1>/dev/null 2>&1
    rm -f /run/dhcpcd/dhcpcd-${MYIF}.pid 2>/dev/null
    rm -f /run/dhcpcd-${MYIF}.pid 2>/dev/null

    # Broadcast and network are derived from IP and netmask:
    LOCAL_BROADCAST=$(ipmask $LOCAL_NETMASK $LOCAL_IPADDR | cut -f 1 -d ' ')
    LOCAL_NETWORK=$(ipmask $LOCAL_NETMASK $LOCAL_IPADDR | cut -f 2 -d ' ')
    if [ -x /etc/rc.d/rc.networkmanager 2>/dev/null ]; then
      # Use nmcli to reconfigure NetworkManager:
      nmcli con add con-name pxe-${MYIF} ifname ${MYIF} type ethernet ip4 $LOCAL_IPADDR/$(mask_cvt $LOCAL_NETMASK)
      if [ "x$GLOBAL_GATEWAY" = "x" -a "x$LOCAL_GATEWAY" != "x" ]; then
        nmcli con mod pxe-${MYIF} ipv4.gateway $LOCAL_GATEWAY
      fi
      nmcli dev connect ${MYIF}
    else
      # Use ifconfig and route commands:
      ifconfig $MYIF $LOCAL_IPADDR netmask $LOCAL_NETMASK broadcast $LOCAL_BROADCAST
      if [ "x$GLOBAL_GATEWAY" = "x" -a "x$LOCAL_GATEWAY" != "x" ]; then
        #echo "Configuring your gateway..."
        route add default gw $LOCAL_GATEWAY metric 1
      fi
    fi
    echo $LOCAL_IPADDR > $TMP/SeTIP
    echo $LOCAL_NETMASK > $TMP/SeTnetmask
    echo $LOCAL_GATEWAY > $TMP/SeTgateway
    clear
    break

  done # end main loop IP configuration

} # end devconfig()

# The PXE Server configuration routine:
pxeconfig() {

  # This function accepts a parameter (network interface to configure).
  # If no name was passed, we will do our best to find out ourselves.

  # Create empty PXE configuration file:
  echo "" > $TMP/SeTpxe

  # Find out what interface we should be using.
  # Did we get one passed as a parameter?
  if [ "x$1" = "x" ]; then
    # No parameter or it was empty; find out if we have a wired interface:
    WIRED_INT=""
    IINT=0
    for WINT in $(ls --indicator-style=none /sys/class/net |grep -v ^lo); do
      if ! grep -q $WINT /proc/net/wireless ; then
        WIRED_INT="$WIRED_INT $WINT"
        IINT=$(( $IINT + 1 ))
      fi
    done
    if [ $IINT -eq 0 ]; then
      # Zero wired interfaces found - exit.
      cat <<EOF > $TMP/tempmsg

Could not find a wired network interface. \n\
A PXE Server needs a configured network interface to work.\n\

EOF
    if [ $DEBUG -ne 0 ]; then read -p "Press ENTER to continue: " JUNK ; fi
    $DIALOG --title "MISSING NETWORK DEVICE" --msgbox "$(cat $TMP/tempmsg)"
8 68
      rm -f $TMP/tempmsg
      exit 1
    elif [ $IINT -eq 1 ]; then
      # Exactly one wired interfaces found - use it.
      INTERFACE=$(echo $WIRED_INT) # get rid of the space
    else
      # Multiple wired interfaces found - let the user select one:
      rm -f $TMP/iflist
      for WINT in $WIRED_INT ; do
        DRIVERTXT="IP=$(ip -f inet -o addr show ${WINT} |tr -s ' ' |head -1 |cut - f4 -d' ' |cut -f1 -d/)"
        if cat /sys/class/net/$WINT/device/uevent 1>/dev/null 2>/dev/null ; then
          DRIVERTXT="$DRIVERTXT driver=$(grep "DRIVER=" /sys/class/net/$WINT/device/uevent |cut -f2 -d=)"
        fi
        echo "$WINT \"network interface ($DRIVERTXT)\"" >> $TMP/iflist
      done
      if [ $DEBUG -ne 0 ]; then read -p "Press ENTER to continue: " JUNK ; fi
      $DIALOG --title "SELECT NETWORK INTERFACE" \
        --menu \
"Select an option below using the UP/DOWN keys and SPACE or ENTER.\n\
Alternate keys may also be used: '+', '-', and TAB." 13 72 9 \
        --file $TMP/iflist \
        2> $TMP/intset
      INTERFACE="$(cat $TMP/intset)"
      rm $TMP/intset $TMP/iflist
    fi
  fi # End undefined INTERFACE

  #
  # We now know what network interface to use.
  #

  # If dhcpcd is running, it likely has a lease from a LAN DHCP server,
  # so we should not activate another DHCP server ourselves now:
  if [ -s $(get_dhcpcd_pid ${INTERFACE}) -a -n "$(ps -q $(cat $(get_dhcpcd_pid ${INTERFACE})) -o comm=)" ]; then
    OWNDHCP="no"
  else
    # Assume nothing... we will ask the user for confirmation later!
    OWNDHCP="yes"
  fi

  # If $INTERFACE != $GLOBAL_GW_INT then we are dealing with a dual-nic setup
  # and later on we can suggest configuring (NAT) routing:
  GLOBAL_GW_INT=$(ip -f inet -o route show default |grep -v linkdown |head -1 |tr -s ' ' |cut -f5 -d' ')
  GLOBAL_GATEWAY=$(ip -f inet -o route show default |grep -v linkdown |head -1 |tr -s ' ' |cut -f3 -d' ')

  #
  # Start the interactive part:
  #

  if [ $DEBUG -ne 0 ]; then read -p "Press ENTER to continue: " JUNK ; fi
  $DIALOG --backtitle "@CDISTRO@ Linux Live (@LIVEDE@) PXE Server." \
   --title "WELCOME TO PXE CONFIGURATION" --msgbox "\
We will be asking you a few questions now.\n\
The answers will be used to start a PXE service on this computer \
which does not interfere with other services in your network.\
\n\
The only assumption is, that there is NO PXE service already \
running on your local network at this moment.
\n\
If in doubt, stick with the defaults." 0 0

  if [ "$OWNDHCP" = "yes" ]; then
    # Be extra safe. Do not start a DHCP server if the user denies it:
    if [ $DEBUG -ne 0 ]; then read -p "Press ENTER to continue: " JUNK ; fi
    $DIALOG --title "ENABLE DHCP SERVER" --yesno " \
Network interface ${INTERFACE} did not get an IP address from a DHCP server. \
Slackware's PXE server starting on ${INTERFACE} needs a working DHCP server.\n\
Do you want this computer to start its own DHCP server on ${INTERFACE} \
(you can control what IP addresses are used by the DHCP server)?\n\
Say 'YES' if you are certain your network interface ${INTERFACE} is
not in reach of any DHCP server." 13 68
    if [ $? = 0 ]; then
      OWNDHCP="yes" 
    else
      OWNDHCP="no" 
    fi
  fi

  # Assemble the network parameters:
  LOCAL_IPADDR=$(ip -f inet -o addr show ${INTERFACE} |tr -s ' ' |head -1 |cut -f4 -d' ' |cut -f1 -d/)
  if [ "x$LOCAL_IPADDR" = "x" ]; then # no IP Address was configured?!?
    cat <<EOF > $TMP/tempmsg

Next step is to define an IP address for network interface ${INTERFACE}. \n\
A PXE Server needs a configured network interface to work.\n\

EOF
    if [ $DEBUG -ne 0 ]; then read -p "Press ENTER to continue: " JUNK ; fi
    $DIALOG --title "UNCONFIGURED NETWORK DEVICE" --msgbox "$(cat $TMP/tempmsg)" 9 68
    rm -f $TMP/tempmsg
    # Run the static IP configuration routine for $INTERFACE:
    devconfig ${INTERFACE}
  else
    # DHCP configured interface, we assume that the default gaeway is here.
    LOCAL_GATEWAY=$GLOBAL_GATEWAY
  fi

  # OK we have an IP Address, let's continue.
  LOCAL_NETMASK=$(ip -f inet -o addr show ${INTERFACE} |tr -s ' ' |head -1 |cut -f4 -d' ' |cut -f2 -d/)
  LOCAL_NETMASK=$(cidr_cvt $LOCAL_NETMASK)
  LOCAL_BROADCAST=$(ipmask $LOCAL_NETMASK $LOCAL_IPADDR |cut -f 1 -d ' ')
  LOCAL_NETWORK=$(ipmask $LOCAL_NETMASK $LOCAL_IPADDR |cut -f 2 -d ' ')

  if [ "$OWNDHCP" = "yes" ]; then
    # Find out a suitable IP address range for the DHCP server. Involves magic:
    I_LOCAL_IPADDR=$(ip_to_int "$LOCAL_IPADDR")
    I_LOCAL_NETMASK=$(ip_to_int "$LOCAL_NETMASK")
    I_MINLEASE_IP=$(( ($I_LOCAL_IPADDR & $I_LOCAL_NETMASK) + 1 ))
    I_MAXLEASE_IP=$(( ($I_LOCAL_IPADDR | ${I_LOCAL_NETMASK}^0xffffffff) - 1 ))
    if [ $(( $I_MAXLEASE_IP - $I_LOCAL_IPADDR )) -ge $DEF_DHCP_RANGE ]; then
      # Use $DEF_DHCP_RANGE IP addresses in the top of the address range:
      I_MINLEASE_IP=$(( $I_MAXLEASE_IP - $(($DEF_DHCP_RANGE - 1)) ))
    elif [ $(($I_LOCAL_IPADDR - $I_MINLEASE_IP)) -ge $DEF_DHCP_RANGE ]; then
      # Use $DEF_DHCP_RANGE IP addresses in the bottom of the address range:
      I_MAXLEASE_IP=$(( $I_MINLEASE_IP + $(($DEF_DHCP_RANGE - 1)) ))
    else
      # Smaller range available than we wanted, use what we can get:
      I_MINLEASE_IP=$(( $I_LOCAL_IPADDR + 1 ))
    fi

    MINLEASE_IP=$(int_to_ip "$I_MINLEASE_IP")
    MAXLEASE_IP=$(int_to_ip "$I_MAXLEASE_IP")

    while [ 0 ]; do
      if [ $DEBUG -ne 0 ]; then read -p "Press ENTER to continue: " JUNK ; fi
      ( $DIALOG --stdout --backtitle "@CDISTRO@ Linux Live (@LIVEDE@) PXE Server." \
          --title "DHCP SERVER CONFIGURATION" \
          --cancel-label Restart \
          --form "\
The PXE Service is going to run on $INTERFACE with these values \
(the defaults should be OK). \n\
You can change the range of IP addresses used by the DHCP server, if \
IP addresses in the proposed range are used by computers in your LAN. \
For instance, your default gateway if you have one. \n\
\n\
Also note that we will not validate any changes you make:" \
    18 68 0 \
    "IP Address:"                  1 1 "$LOCAL_IPADDR"   1 30   0 0 \
    "Netmask:"                     2 1 "$LOCAL_NETMASK"  2 30   0 0 \
    "Gateway:"                     3 1 "$LOCAL_GATEWAY"  3 30   0 0 \
    "Lowest DHCP Client Address:"  4 1 "$MINLEASE_IP"    4 30  15 0 \
    "Highest DHCP Client Address:" 5 1 "$MAXLEASE_IP"    5 30  15 0 \
      ) > $TMP/tempopts

      if [ $? = 0 ]; then
        # Remember... busybox ash is no good with arrays :/
        local i=0
        rm -f $TMP/tempkeys
        cat $TMP/tempopts | while read VALUE ; do
          if   [ $i = 0 ]; then echo "MINLEASE_IP=\"$VALUE\"" >> $TMP/tempkeys
          elif [ $i = 1 ]; then echo "MAXLEASE_IP=\"$VALUE\"" >> $TMP/tempkeys
          fi
          i=$(expr $i + 1)
        done
        eval $(cat $TMP/tempkeys)
        rm $TMP/tempopts
        break
      fi
    done
  else
    if [ $DEBUG -ne 0 ]; then read -p "Press ENTER to continue: " JUNK ; fi
    $DIALOG --backtitle "@CDISTRO@ Linux Live (@LIVEDE@) PXE Server." \
      --title "DHCP SERVER CONFIGURATION" --msgbox "\
\n\
PXE server has been configured to use a DHCP server in your network.\n\
\n\
Press ENTER to continue." 14 68
  fi # [ "$OWNDHCP" = "yes" ]

  echo "DHCP=${OWNDHCP}" >> $TMP/SeTpxe
  echo "GLOBAL_GATEWAY=${GLOBAL_GATEWAY}" >> $TMP/SeTpxe
  echo "GLOBAL_GW_INT=${GLOBAL_GW_INT}" >> $TMP/SeTpxe
  echo "LOCAL_IPADDR=${LOCAL_IPADDR}" >> $TMP/SeTpxe
  echo "LOCAL_NETMASK=${LOCAL_NETMASK}" >> $TMP/SeTpxe
  echo "LOCAL_GATEWAY=${LOCAL_GATEWAY}" >> $TMP/SeTpxe
  echo "LOCAL_BROADCAST=${LOCAL_BROADCAST}" >> $TMP/SeTpxe
  echo "LOCAL_NETWORK=${LOCAL_NETWORK}" >> $TMP/SeTpxe
  echo "MINLEASE_IP=${MINLEASE_IP}" >> $TMP/SeTpxe
  echo "MAXLEASE_IP=${MAXLEASE_IP}" >> $TMP/SeTpxe

  # Write out a suitable dnsmasq configuration:
  cat <<EOF > ${TMP}/pxe_dnsmasq.conf
# Only listen at our designated interface:
listen-address=$LOCAL_IPADDR

# Write the pid file:
pid-file=${TMP}/pxe_dnsmasq.pid

# Start a TFTP server:
enable-tftp

# Set the root directory for files available via FTP:
tftp-root=/var/lib/tftpboot

# Disable re-use of the DHCP servername and filename fields as extra
# option space. That's to avoid confusing some old or broken DHCP clients.
dhcp-no-override

# Log connections so that we can display them on the console:
log-facility=/var/log/pxe_dnsmasq.log
log-dhcp

# Custom path for the leases file:
dhcp-leasefile=$TMP/pxe_dnsmasq.leases

# Test for the architecture of a netboot client. PXE clients are
# supposed to send their architecture as option 93. (See RFC 4578) .
# The known types are x86PC, PC98, IA64_EFI, Alpha, Arc_x86,
# Intel_Lean_Client, IA32_EFI, BC_EFI, Xscale_EFI and X86-64_EFI
dhcp-match=x86PC,      option:client-arch, 0  #BIOS x86
dhcp-match=BC_EFI,     option:client-arch, 7  #EFI Byte Code
dhcp-match=X86-64_EFI, option:client-arch, 9  #EFI x86_64 

# Craft a nice PXE menu (user has 3 seconds to interrupt in which case the
# network boot sequence will be aborted):
pxe-prompt="PXE booting in 3 seconds...", 3

# Now let's build a boot menu. If there's only one menu item PXE will
# automatically boot into this. If thre are multiple boot selections,
# then user input is expected.
# I found out that UEFI PXE boot with more than one menu item won't work.
# The 'pxe-service' definitions are the PXE alternative to the generic
# 'dhcp-boot' keyword.

# The PXE boot image has to match the client architecture.
# And we enforce that our own TFTP server is being used so that misbehaving
# DHCP servers on the LAN that set 'next-server' are not affecting us:
pxe-service=X86PC, "Boot from network (BIOS)", pxelinux,${LOCAL_IPADDR}
pxe-service=BC_EFI, "Boot from network (UEFI)", ${UEFIPREFIX}/bootx64.efi,${LOCAL_IPADDR}
pxe-service=X86-64_EFI, "Boot from network (UEFI)", ${UEFIPREFIX}/bootx64.efi,${LOCAL_IPADDR}

# A boot service type of 0 is special, and will abort the
# net boot procedure and continue booting from local media.
pxe-service=X86PC, "Boot from local hard disk", 0

# Note:
# The above 'pxe-service' menu does not always work for UEFI-based clients,
# so alternatively you could implement a combination of 'dhcp-match' and
# 'dhcp-boot' to provide a boot image. Here is a commented-out example:
#dhcp-match=set:efi-x86_64,option:client-arch,7
#dhcp-match=set:efi-x86_64,option:client-arch,9
#dhcp-match=set:efi-x86,option:client-arch,6
#dhcp-match=set:bios,option:client-arch,0
#dhcp-boot=tag:efi-x86_64,"${UEFIPREFIX}/bootx64.efi"
#dhcp-boot=tag:efi-x86,"${UEFIPREFIX}/bootia32.efi"
#dhcp-boot=tag:bios,"bios/lpxelinux.0"

EOF

  if [ -n "$LOCAL_GATEWAY" -a "$INTERFACE" = "$GLOBAL_GW_INT"  ]; then
    # The default gw can be reached through our $INTERFACE.
    cat <<EOF >> ${TMP}/pxe_dnsmasq.conf
# Override the default route supplied by dnsmasq, which assumes the
# router is the same machine as the one running dnsmasq.
# The two options below are equivalent:
#dhcp-option=option:router,${LOCAL_GATEWAY}
dhcp-option=3,${LOCAL_GATEWAY}

EOF
  else
    # The default gw is reached through a second interface on the computer.
    # We need to build a router, a bridge or a NAT firewall between the two.
    cat <<EOF >> ${TMP}/pxe_dnsmasq.conf
# Apply the default route supplied by dnsmasq, which assumes the
# router is the same machine as the one running dnsmasq.
# And we want to let our PXE clients use $INTERFACE as the default gw.
#dhcp-option=option:router,${LOCAL_IPADDR}

EOF
  fi

  if [ "$OWNDHCP" = "yes" ]; then
    cat <<EOF >> ${TMP}/pxe_dnsmasq.conf
# dnsmasq functions as a normal DHCP server, providing IP leases.
dhcp-range=${MINLEASE_IP},${MAXLEASE_IP},${LOCAL_NETMASK},1h

EOF
  else
    cat <<EOF >> ${TMP}/pxe_dnsmasq.conf
# There is an existing DHCP server on this LAN, so dnsmasq functions
# as a proxy DHCP server providing boot information but no IP leases.
# Any ip in the subnet will do, so you may just put your server NIC ip here.
dhcp-range=${LOCAL_IPADDR},proxy

EOF
  fi

  # Create the pxelinux configuration file for BIOS boot:
  KBD=$(sed -n "s%^ */usr/bin/loadkeys *%%p" /etc/rc.d/rc.keymap 2>/dev/null)
  cat <<EOF > /var/lib/tftpboot/pxelinux.cfg/default
prompt 0
timeout 300
ui vesamenu.c32
default pxelive

menu background swlogov.png
menu title @CDISTRO@ Linux Live PXE boot menu
menu clear

F1 pxemessage.txt #00000000
F2 f2.txt #00000000
F3 f3.txt #00000000
F4 f4.txt #00000000

menu hshift 1
menu vshift 9
menu width 45
menu margin 1
menu rows 10
menu helpmsgrow 14
menu helpmsgendrow 18
menu cmdlinerow 18
menu tabmsgrow 19
menu timeoutrow 20

menu color screen       37;40      #00000000 #00000000 none
menu color border       34;40      #00000000 #00000000 none
menu color title        1;36;44    #ffb9556b #30002d1f none
menu color unsel        37;44      #ff354172 #007591ff none
menu color hotkey       1;37;44    #ffad37b7 #00000000 none
menu color sel          7;37;40    #ffffffff #00000000 none
menu color hotsel       1;7;37;40  #ffe649f3 #00000000 none
menu color scrollbar    30;44      #00000000 #00000000 none
menu color tabmsg       31;40      #ffA32222 #00000000 none
menu color cmdmark      1;36;40    #ffff0000 #00000000 none
menu color cmdline      37;40      #ffffffff #ff000000 none
menu color pwdborder    30;47      #ffff0000 #00000000 std
menu color pwdheader    31;47      #ffff0000 #00000000 std
menu color pwdentry     30;47      #ffff0000 #00000000 std
menu color timeout_msg  37;40      #ff809aef #00000000 none
menu color timeout      1;37;40    #ffb72f9f #00000000 none
menu color help         37;40      #ff354172 #00000000 none

label pxelive
  menu label Boot @CDISTRO@ Linux Live (@LIVEDE@) from network
  kernel /generic
  append initrd=/initrd.img load_ramdisk=1 prompt_ramdisk=0 rw printk.time=0 nfsroot=${LOCAL_IPADDR}:/mnt/livemedia luksvol= nop hostname=@DISTRO@ tz=$(cat /etc/timezone) locale=${SYSLANG:-"en_US.UTF-8"} kbd=${KBD:-"us"}
EOF

  # And a Grub configuration for UEFI boot:
  cat <<EOF > /var/lib/tftpboot${UEFIPREFIX}/grub.cfg
# PXE boot menu for UEFI based systems:

set default=0
set timeout=200

# EFI video support:
insmod efi_gop
insmod efi_uga
# (U)EFI requirement: must support all_video:
insmod all_video

# Load the network modules first, so that we can use \$prefix;
insmod net
insmod efinet
insmod tftp

insmod gzio
insmod part_gpt
insmod ext2

# Determine whether we can show a graphical themed menu:
insmod font
if loadfont \$prefix/theme/dejavusansmono12.pf2 ; then
  loadfont \$prefix/theme/dejavusansmono10.pf2
  loadfont \$prefix/theme/dejavusansmono5.pf2
  set font="DejaVu Sans Mono Regular 12"
  set gfxmode=1024x768,800x600,640x480,auto
  export gfxmode
  insmod gfxterm
  insmod gfxmenu
  terminal_output gfxterm
  insmod gettext
  insmod png
  set theme=\$prefix/theme/liveslak.txt
  export theme
fi

set gfxpayload=keep

menuentry 'Boot @CDISTRO@ Linux Live (@LIVEDE@) from network' --class slackware --class gnu-linux --class gnu --class os {
  echo "Loading @CDISTRO@ kernel"
  linux generic load_ramdisk=1 prompt_ramdisk=0 rw printk.time=0 nfs root=${LOCAL_IPADDR}:/mnt/livemedia luksvol= nop hostname=@DISTRO@ tz=$(cat /etc/timezone) locale=${SYSLANG:-"en_US.UTF-8"} kbd=${KBD:-"us"}
  initrd initrd.img
  echo "Booting @CDISTRO@ kernel"
}
EOF

} # end of pxeconfig()

# -------------------------------------------------------- #
# Above was just initialization and function definitions.  #
# Let's make use of all that.                              #
# ---------------------------------------------------------#

# Main loop:
while [ 0 ]; do

  if [ $DEBUG -ne 0 ]; then read -p "Press ENTER to continue: " JUNK ; fi
  $DIALOG --title "@CDISTRO@ Linux Live PXE Server (@LIVEDE@ @SL_VERSION@)" \
    --menu \
"Welcome to @CDISTRO@ Linux Live PXE Server.\n\
Select an option below using the UP/DOWN keys and SPACE or ENTER.\n\
Alternate keys may also be used: '+', '-', and TAB." 13 72 9 \
"NETWORK" "Configure your network parameters" \
"ACTIVATE" "Activate the @CDISTRO@ PXE Server" \
"EXIT" "Exit @CDISTRO@ PXE Setup" 2> $TMP/hdset
  if [ ! $? = 0 ]; then
    rm -f $TMP/hdset $TMP/SeT*
    exit
  fi
  MAINSELECT="`cat $TMP/hdset`"
  rm $TMP/hdset

  # Start checking what to do. Some modules may reset MAINSELECT to run the
  # next item in line.

  if [ "$MAINSELECT" = "NETWORK" ]; then
    # Set up our network. We may not know anything yet in which case
    # the variable $INTERFACE will be empty.
    pxeconfig $INTERFACE
    if [ -r $TMP/SeTpxe ]; then
      MAINSELECT="ACTIVATE"
    fi
  fi
 
  if [ "$MAINSELECT" = "ACTIVATE" ]; then
    if [ ! -r $TMP/SeTpxe ]; then
      if [ $DEBUG -ne 0 ]; then read -p "Press ENTER to continue: " JUNK ; fi
      $DIALOG --title "CANNOT START PXE SERVER YET" --msgbox "\
\n\
Before you can start the PXE Server, complete the following task:\n\
\n\
(*) Set up your computer's network parameters.\n\
\n\
Press ENTER to return to the main menu." 14 68
      continue
    else
      if [ $DEBUG -ne 0 ]; then read -p "Press ENTER to continue: " JUNK ; fi
      $DIALOG --title "READY TO START PXE SERVER" --msgbox "\
\n\
Ready to start the PXE Server!\n\
The PXE server log will be displayed in the next screen.
\n\
Press ENTER to start." 14 68
    fi

    # Time to start the BOOTP/TFTP/NFS servers:
    echo > /var/log/pxe_dnsmasq.log
    dnsmasq -C ${TMP}/pxe_dnsmasq.conf -z -i ${INTERFACE}
    if ! grep -q "^/mnt/livemedia" /etc/exports ; then
      # Without 'fsid' nfsd refuses to export the filesystem if it RAM based;
      # the number '14' could be any unique low-range number:
      cat <<EOT >> /etc/exports
/mnt/livemedia  ${LOCAL_NETWORK}/${LOCAL_NETMASK}(ro,sync,insecure,no_subtree_check,root_squash,fsid=14)
EOT
    fi
    sh /etc/rc.d/rc.nfsd restart
    if [ "$INTERFACE" != "$GLOBAL_GW_INT" ]; then
      # The default gateway for this computer is on another interface;
      # we need to enable forwarding:
      OLDROUTING=$(cat /proc/sys/net/ipv4/ip_forward)
      echo 1 > /proc/sys/net/ipv4/ip_forward
      # also start the route daemon:
      if [ -z "$(pidof routed)" ]; then
        /usr/sbin/routed -g -s
      fi
    else
      OLDROUTING=""
    fi

    if [ $DEBUG -ne 0 ]; then read -p "Press ENTER to continue: " JUNK ; fi
    $DIALOG --backtitle "@CDISTRO@ Linux Live PXE Server." \
      --title "PXE Client activity log" \
      --ok-label "EXIT" \
      --tailbox /var/log/pxe_dnsmasq.log 20 68

    # Time to kill the BOOTP/TFTP/NFS servers:
    [ -n "$OLDROUTING" ] && echo $OLDROUTING > /proc/sys/net/ipv4/ip_forward
    kill -TERM $(cat ${TMP}/pxe_dnsmasq.pid)
    sh /etc/rc.d/rc.nfsd stop
    sed -i -e "s%^/mnt/livemedia.*%#&%" /etc/exports
  fi

  if [ "$MAINSELECT" = "EXIT" ]; then
    clear
    break
  fi

done # end of main loop

# end @CDISTRO@ Linux Live PXE Server script

