REQUIRED_DISTRO_FEATURES = "x11"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append += " \
	file://enable-chromecast-by-default.patch \
	file://ffmpeg_chromium.patch \
	file://add_GL_RGB_YCRCB_420_CHROMIUM.patch \
	file://widevine.patch \
	file://arm_neon.patch \
	file://0001-Add-support-for-V4L2VDA-on-Linux.patch \
	file://0002-Add-mmap-via-libv4l-to-generic_v4l2_device.patch \
	file://0003-media-capture-linux-Support-libv4l2-plugins.patch \
	file://0004-media-Enable-mojo-media-when-using-v4l2-codec-on-des.patch \
	file://0005-cld3-Avoid-unaligned-accesses.patch \
	file://0006-media-gpu-v4l2-Use-POLLIN-for-pending-event.patch \
	file://0008-media-capture-linux-Prefer-using-the-first-device.patch \
	file://0009-media-gpu-v4l2-Fix-compile-error-when-ozone-not-enab.patch \
	file://0010-media-gpu-Only-add-libva-when-use_vaapi.patch \
	file://0001-ozone-wayland-watch-fd-on-a-dedicated-thread.patch \
	file://angle_gl_enable_when_ozone_wl.patch \
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
 "

GN_ARGS += " \
 enable_hangout_services_extension=true \
 enable_widevine=true \
 rtc_use_pipewire=true \
 rtc_pipewire_version="0.3" \
 link_pulseaudio=true \
 ozone_platform_x11=true \
 enable_mdns=true \
 rtc_use_h264=true \
 arm_use_thumb=false \
 arm_use_neon=true \
 arm_optionally_use_neon=false \
 use_v4l2_codec=true \
 use_v4lplugin=true \
 use_linux_v4l2_only=true \
"

CHROMIUM_EXTRA_ARGS_append = " --no-sandbox --gpu-sandbox-start-early --ignore-gpu-blocklist --enable-native-gpu-memory-buffers --enable-zero-copy --num-raster-threads=4 --audio-buffer-size=4096 --enable-accelerated-video-decode"
