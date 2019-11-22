require conf/license/odroid-os-gplv2.inc

inherit image

DEPENDS += " \
	zip-native \
"

IMAGE_INSTALL = "\
	${ROOTFS_PKGMANAGE} \
	avahi-daemon \
	ca-certificates \
	dropbear \
	e2fsprogs-e2fsck \
	e2fsprogs-mke2fs \
	e2fsprogs-tune2fs \
	fuse-exfat \
	glibc-binary-localedata-en-gb \
	nfs-utils-client \
	openssh-sftp \
	openssh-sftp-server \
	opkg \
	packagegroup-base \
	packagegroup-core-boot \
	parted \
	nfs-utils \
	samba-base \
	sdparm \
	tzdata \
	vsftpd \
"

IMAGE_LINGUAS = ""
IMAGE_FEATURES += "package-management"

# Remove the mysterious var/lib/opkg/lists that appears to be the result
# of the installer that populates the rootfs. I wanted to call this
# rootfs_remove_opkg_leftovers but that fails to parse.
rootfs_removeopkgleftovers() {
	rm -r ${IMAGE_ROOTFS}/var/lib/opkg/lists
}

# Speedup boot by reducing the host key size. The time it takes grows
# exponentially by key size, the default is 2k which takes several
# seconds on most boxes.
rootfs_speedup_dropbearkey() {
	echo 'DROPBEAR_RSAKEY_ARGS="-s 1024"' >> ${IMAGE_ROOTFS}${sysconfdir}/default/dropbear
}

# Some features in image.bbclass we do NOT want, so override them
# to be empty. We want to log in as root, but NOT via SSH. So we want
# to live without debug-tweaks...
zap_root_password () {
	true
}

ssh_allow_empty_password () {
	true
}

license_create_manifest() {
}

ROOTFS_POSTPROCESS_COMMAND += "rootfs_removeopkgleftovers; rootfs_speedup_dropbearkey; "

IMAGE_INSTALL += "chromium-ozone-wayland weston wayland firefox"

export IMAGE_BASENAME = "odroid-os-wayland"
