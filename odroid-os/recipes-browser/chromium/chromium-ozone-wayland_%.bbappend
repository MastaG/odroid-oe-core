FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
	file://chromium-widevine.patch \
	file://0001-generic_v4l2_device-allow-NV12-YVU420-on-all-ARM-pla.patch \
	"

PACKAGECONFIG = "proprietary-codecs use-egl impl-side-painting use-linux-v4l2 cups"

GN_ARGS += " \
 enable_hangout_services_extension=true \
 enable_widevine=true \
 use_system_minigbm=false \
 use_system_libdrm=false \
 use_exynos_minigbm=true \
"
