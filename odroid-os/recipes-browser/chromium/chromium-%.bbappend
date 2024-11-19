FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

GN_UNBUNDLE_LIBS = ""

SRC_URI:append = "\
        file://0001-HACK-media-Support-V4L2-video-decoder.patch \
        file://0002-HACK-media-gpu-v4l2-Enable-V4L2-VEA.patch \
        file://0003-media-gpu-v4l2-Gen-libv4l2_stubs.patch \
        file://0004-media-gpu-v4l2-Support-libv4l2-plugins.patch \
        file://0005-media-capture-linux-Support-libv4l2-plugins.patch \
        file://0007-media-gpu-v4l2-Use-POLLIN-for-pending-event.patch \
        file://0008-media-capture-linux-Prefer-using-the-first-device.patch \
        file://0009-media-gpu-v4l2-Fix-compile-error-when-ozone-not-enab.patch \
        file://0010-Create-new-fence-when-there-s-no-in-fences.patch \
        file://0011-HACK-ozone-wayland-Force-disable-implicit-external-s.patch \
        file://0012-HACK-media-capture-linux-Allow-camera-without-suppor.patch \
        file://0013-content-gpu-Only-depend-dri-for-X11.patch \
        file://0014-media-gpu-sandbox-Only-depend-dri-for-X11.patch \
        file://0015-ui-gfx-linux-Force-disabling-modifiers.patch \
        file://0016-HACK-ui-x11-Fix-config-choosing-error-with-Mali-DDK.patch \
        file://0017-Run-blink-bindings-generation-single-threaded.patch \
        file://0018-ozone-wayland-Check-format-supported-by-gbm-for-crea.patch \
        file://use-oauth2-client-switches-as-default.patch \
        file://widevine.patch \
        file://misc-fixes.patch \
"

# file://arm_neon.patch
# file://0006-cld3-Avoid-unaligned-accesses.patch

PACKAGECONFIG[use-linux-v4l2] = "use_v4l2_codec=true use_v4lplugin=true use_linux_v4l2_only=true"
PACKAGECONFIG = "proprietary-codecs use-egl cups use-linux-v4l2 gtk4"

DEPENDS:append = " pipewire"

DEPENDS:remove = "\
        flac \
        jpeg \
        libxslt \
"

GN_ARGS:remove = "\
        use_system_libjpeg=true \
"

GN_ARGS:append = "\
        enable_hangout_services_extension=true \
        enable_widevine=true \
        enable_mdns=true \
        arm_use_neon=true \
        rtc_use_pipewire=true \
        fatal_linker_warnings=false \
        blink_enable_generated_code_formatting=false \
        blink_symbol_level=0 \
"

CFLAGS:remove:arm = "-g"
CXXFLAGS:remove:arm = "-g"

CHROMIUM_EXTRA_ARGS:remove = "--use-gl=egl"
CHROMIUM_EXTRA_ARGS:append = " --use-gl=angle --use-angle=gles-egl --use-cmd-decoder=passthrough"

do_configure:prepend() {
        cd ${S}
        # Allow building against system libraries in official builds
        sed -i 's/OFFICIAL_BUILD/GOOGLE_CHROME_BUILD/' tools/generate_shim_headers/generate_shim_headers.py
        sed -i -e 's/\<xmlMalloc\>/malloc/' -e 's/\<xmlFree\>/free/' -e '1i #include <cstdlib>' third_party/blink/renderer/core/xml/*.cc third_party/blink/renderer/core/xml/parser/xml_document_parser.cc third_party/libxml/chromium/*.cc

}

CHROMIUM_EXTRA_ARGS:append = " --ignore-gpu-blocklist --ignore-gpu-blacklist --enable-accelerated-video-decode"
# --enable-native-gpu-memory-buffers --enable-zero-copy --num-raster-threads=4 --audio-buffer-size=4096"
CHROMIUM_EXTRA_ARGS:append = " --enable-features=VaapiVideoDecoder,VaapiVideoEncoder"
