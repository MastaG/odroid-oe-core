FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append += " \
	file://chromium-widevine.patch \
        file://sync-enable-USSPasswords-by-default.patch \
	file://remove-verbose-logging-in-local-unique-font-matching.patch \
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
	pipewire \
"

GN_UNBUNDLE_LIBS_append += " \
	fontconfig \
	freetype \
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

# Don't explicitly disable remoting
GN_ARGS_remove = "enable_remoting=false"

# Also enable X11
GN_ARGS_remove = "ozone_platform_x11=false"

# Build using provided libgbm and libdrm
# GN_ARGS_remove = "use_system_minigbm=true"
# GN_ARGS_remove = "use_system_libdrm=true"


GN_ARGS += " \
 ${@bb.utils.contains('DISTRO_FEATURES', 'pulseaudio', 'link_pulseaudio=true', '', d)} \
 enable_hangout_services_extension=true \
 enable_widevine=true \
 ozone_platform_x11=true \
 rtc_use_pipewire=true \
"

CHROMIUM_EXTRA_ARGS_append = " --ignore-gpu-blacklist --enable-native-gpu-memory-buffers --enable-zero-copy --num-raster-threads=4 --audio-buffer-size=4096"

PROVIDES += "chromium"
