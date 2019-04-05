FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
	file://chromium-widevine.patch \
	file://0001-generic_v4l2_device-allow-NV12-YVU420-on-all-ARM-pla.patch \
	"

DEPENDS += "\
	libx11 \
	libxcomposite \
	libxcursor \
	libxdamage \
	libxext \
	libxfixes \
	libxi \
	libxrandr \
	libxrender \
	libxscrnsaver \
	libxtst \
"

PACKAGECONFIG = "proprietary-codecs use-egl impl-side-painting use-linux-v4l2 cups"

GN_ARGS += " \
 remove_webcore_debug_symbols=true \
 blink_symbol_level=0 \
 symbol_level=2 \
 enable_hangout_services_extension=true \
 enable_widevine=true \
 use_system_minigbm=false \
 use_system_libdrm=false \
 use_exynos_minigbm=true \
 ozone_platform_x11=true \
 ozone_platform_gbm=true \
 enable_package_mash_services=true \
 build_display_configuration=true \
 
"

CHROMIUM_EXTRA_ARGS_append = " --in-process-gpu --ignore-gpu-blacklist --enable-native-gpu-memory-buffers --enable-zero-copy --num-raster-threads=4 --audio-buffer-size=4096 --enable-features=Mash "
CHROMIUM_EXTRA_ARGS_append = " --user-agent \"Mozilla/5.0 \(X11; CrOS armv7l 10895.56.0\) AppleWebKit/537.36 \(KHTML, like Gecko\) Chrome/${PV} Safari/537.36\" "
