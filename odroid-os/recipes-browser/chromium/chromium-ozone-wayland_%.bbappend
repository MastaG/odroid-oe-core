FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
	file://chromium-skia-harmony.patch \
	file://chromium-widevine.patch \
	file://fix-wrong-string-initialization-in-LinkedHashSet.patch \
	file://include-memory-in-one_euro_filter.h.patch \
	file://link-against-harfbuzz-subset.patch \
	"

DEPENDS += "\
	fontconfig \
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

GN_UNBUNDLE_LIBS += " \
	fontconfig \
	freetype \
"

do_configure_prepend() {
	cd ${S}
	# Allow building against system libraries in official builds
	sed -i 's/OFFICIAL_BUILD/GOOGLE_CHROME_BUILD/' tools/generate_shim_headers/generate_shim_headers.py
	# https://crbug.com/893950
	sed -i -e 's/\<xmlMalloc\>/malloc/' -e 's/\<xmlFree\>/free/' third_party/blink/renderer/core/xml/*.cc third_party/blink/renderer/core/xml/parser/xml_document_parser.cc third_party/libxml/chromium/libxml_utils.cc
}


PACKAGECONFIG = "proprietary-codecs use-egl impl-side-painting use-linux-v4l2 cups"

GN_ARGS += " \
 ${@bb.utils.contains('DISTRO_FEATURES', 'pulseaudio', 'link_pulseaudio=true', '', d)} \
 symbol_level=2 \
 enable_hangout_services_extension=true \
 enable_widevine=true \
 ozone_platform_x11=true \
 ozone_platform_gbm=true \
 use_system_minigbm=false \
 use_system_libdrm=false \
 use_exynos_minigbm=true \
 rtc_use_pipewire=true \
 enable_swiftshader=false \
"

CHROMIUM_EXTRA_ARGS_append = " --in-process-gpu --ignore-gpu-blacklist --enable-native-gpu-memory-buffers --enable-zero-copy --num-raster-threads=4 --audio-buffer-size=4096"

PROVIDES = "chromium"
