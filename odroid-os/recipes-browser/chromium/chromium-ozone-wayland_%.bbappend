FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append += " file://chromium-widevine.patch "

PACKAGECONFIG = "proprietary-codecs use-egl impl-side-painting use-linux-v4l2 cups"

GN_ARGS += " \
 enable_hangout_services_extension=true \
 use_wayland_gbm=true \
 enable_widevine=true \
 use_lld=${@bb.utils.contains('DISTRO_FEATURES', 'ld-is-lld', 'true', 'false', d)} \
 use_system_minigbm=false \
 use_exynos_minigbm=true \
"
