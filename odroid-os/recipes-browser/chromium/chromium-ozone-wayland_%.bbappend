FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
	file://0001-generic_v4l2_device-allow-NV12-YVU420-on-all-ARM-pla.patch \
	file://chromium-fix-the-flash-for-new-windows.patch \
	file://chromium-fix-window-flash-for-some-WMs.patch \
	file://chromium-glibc-2.29.patch \
	file://chromium-skia-harmony.patch \
	file://chromium-system-icu.patch \
	file://chromium-widevine.patch \
	file://0001-ozone-wayland-Do-not-add-window-if-manager-does-not-.patch \
	file://0001-ozone-wayland-Fix-NativeGpuMemoryBuffers-usage.patch \
	"

GN_UNBUNDLE_LIBS = " \
        flac \
        fontconfig \
        freetype \
        harfbuzz-ng \
        icu \
        libjpeg \
        libwebp \
        libxml \
        libxslt \
        yasm \
"

DEPENDS += "\
	fontconfig \
	harfbuzz \
	icu \
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
"

# Due to building against the system icu library, icudtl.dat is not created inside the build directory.
# So create an empty file to satisfy the original do_install function and delete it afterwards if it is empty.

do_install_prepend() {
	touch icudtl.dat
}

do_install_append() {
	if [ ! -s ${D}${libdir}/chromium/icudtl.dat ]
	then
		rm -f ${D}${libdir}/chromium/icudtl.dat
	fi
}

CHROMIUM_EXTRA_ARGS_append = " --in-process-gpu --ignore-gpu-blacklist --enable-native-gpu-memory-buffers --enable-zero-copy --num-raster-threads=4 --audio-buffer-size=4096 "

PROVIDES = "chromium"
