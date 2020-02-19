# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="GRUB configuration files"
HOMEPAGE=""
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="sys-boot/grub"

S="${FILESDIR}"

src_install() {
	dodir "etc/default" || die
	insinto "etc/default" || die
	newins grub grub.example || die
}

pkg_preinst() {
	if [[ -f ""${ROOT}"etc/default/grub" ]]; then
		mv ""${ROOT}"etc/default/grub" ""${ROOT}"etc/default/grub.bak"
	fi
}

pkg_postinst() {
	if [[ -f ""${ROOT}"etc/default/grub.bak" ]]; then
		mv ""${ROOT}"etc/default/grub.bak" ""${ROOT}"etc/default/grub"
	fi
}
