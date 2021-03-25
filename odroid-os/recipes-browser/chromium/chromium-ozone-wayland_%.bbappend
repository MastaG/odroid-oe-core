REQUIRED_DISTRO_FEATURES = "x11"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
RUNTIME = "llvm"

SRC_URI_append += " \
	file://chromium-glibc-2.33.patch \
	file://x11-ozone-fix-two-edge-cases.patch \
	"

do_configure_prepend() {
	cd ${S}
	# Force script incompatible with Python 3 to use /usr/bin/python2
	sed -i '1s|python$|&2|' third_party/dom_distiller_js/protoc_plugins/*.py
	# Allow building against system libraries in official builds
	sed -i 's/OFFICIAL_BUILD/GOOGLE_CHROME_BUILD/' tools/generate_shim_headers/generate_shim_headers.py
	# https://crbug.com/893950
	sed -i -e 's/\<xmlMalloc\>/malloc/' -e 's/\<xmlFree\>/free/' third_party/blink/renderer/core/xml/*.cc third_party/blink/renderer/core/xml/parser/xml_document_parser.cc third_party/libxml/chromium/libxml_utils.cc
}


PACKAGECONFIG = "proprietary-codecs use-egl impl-side-painting cups"

DEPENDS += " \
	pipewire \
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

GN_ARGS_remove = " \
 ozone_platform_x11=false \
 use_gtk=false \
 use_x11=false \
 "

GN_ARGS += " \
 enable_hangout_services_extension=true \
 enable_widevine=true \
 rtc_use_pipewire=true \
 rtc_pipewire_version="0.3" \
 link_pulseaudio=true \
 ozone_platform_x11=true \
"

CHROMIUM_EXTRA_ARGS_append = " --ignore-gpu-blocklist --enable-native-gpu-memory-buffers --enable-zero-copy --num-raster-threads=4 --audio-buffer-size=4096"
