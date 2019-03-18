FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append += " \
	file://chromium-widevine.patch \
	file://minigbm_define_GBM_BO_IMPORT_FD_MODIFIER.patch;patchdir=third_party/minigbm/src \
	"

PACKAGECONFIG = "proprietary-codecs use-egl impl-side-painting use-linux-v4l2 cups"

GN_ARGS += " \
 enable_hangout_services_extension=true \
 enable_widevine=true \
 use_system_minigbm=false \
 use_system_libdrm=false \
 use_exynos_minigbm=true \
"
