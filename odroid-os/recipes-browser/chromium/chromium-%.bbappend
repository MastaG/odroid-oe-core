FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = "\
        file://0001-media-gpu-v4l2-VD-Add-sequenced_task_runner_handle.h.patch \
        file://0002-Add-support-for-V4L2VDA-on-Linux.patch \
        file://0003-Add-mmap-via-libv4l-to-generic_v4l2_device.patch \
        file://0004-media-capture-linux-Support-libv4l2-plugins.patch \
        file://0005-media-Enable-mojo-media-when-using-v4l2-codec-on-des.patch \
        file://0006-cld3-Avoid-unaligned-accesses.patch \
        file://0007-media-gpu-v4l2-Use-POLLIN-for-pending-event.patch \
        file://0008-media-capture-linux-Prefer-using-the-first-device.patch \
        file://0009-media-gpu-v4l2-Fix-compile-error-when-ozone-not-enab.patch \
        file://0010-ui-events-ozone-Define-SW_PEN_INSERTED-for-old-kerne.patch \
        file://0011-Create-new-fence-when-there-s-no-in-fences.patch \
        file://0012-HACK-ozone-wayland-Force-disable-implicit-external-s.patch \
        file://0013-HACK-media-capture-linux-Allow-camera-without-suppor.patch \
        file://0014-content-gpu-Only-depend-dri-for-X11.patch \
        file://0015-blink-rtc-Force-disabling-optimized-video-scaling.patch \
        file://0016-HACK-media-Disable-chromeos-direct-video-decoder-by-.patch \
        file://0017-media-gpu-v4l2-Non-blocking-initialize.patch \
        file://widevine.patch \
        file://arm_neon.patch \
        file://unexpire-accelerated-video-decode-flag.patch;striplevel=0 \
        file://use-oauth2-client-switches-as-default.patch \
        file://bo.patch \
        file://chromium-98-EnumTable-crash.patch \
        file://chromium-InkDropHost-crash.patch \
        file://chromium-98-system-libdrm.patch \
        file://chromium-91-sql-standard-layout-type.patch \
        file://chromium-98-MiraclePtr-gcc-ice.patch \
        file://chromium-98-WaylandFrameManager-check.patch \
        file://chromium-97-arm-tflite-cast.patch \
"

PACKAGECONFIG = "proprietary-codecs use-egl cups"

GN_ARGS:append = "\
        enable_hangout_services_extension=true \
        enable_widevine=true \
        enable_mdns=true \
        arm_use_thumb=false \
        arm_use_neon=true \
        arm_optionally_use_neon=false \
        use_v4l2_codec=true \
        use_v4lplugin=true \
        use_linux_v4l2_only=true \
        use_gtk=true \
        use_glib=true \
"

do_configure:prepend() {
        cd ${S}
        # Force script incompatible with Python 3 to use /usr/bin/python2
        sed -i '1s|python$|&2|' third_party/dom_distiller_js/protoc_plugins/*.py
        # Allow building against system libraries in official builds
        sed -i 's/OFFICIAL_BUILD/GOOGLE_CHROME_BUILD/' tools/generate_shim_headers/generate_shim_headers.py
        # https://crbug.com/893950
        sed -i -e 's/\<xmlMalloc\>/malloc/' -e 's/\<xmlFree\>/free/' third_party/blink/renderer/core/xml/*.cc third_party/blink/renderer/core/xml/parser/xml_document_parser.cc third_party/libxml/chromium/libxml_utils.cc
}

CHROMIUM_EXTRA_ARGS:append = " --no-sandbox --gpu-sandbox-start-early --ignore-gpu-blocklist --enable-native-gpu-memory-buffers --enable-zero-copy --num-raster-threads=4 --audio-buffer-size=4096 --enable-accelerated-video-decode --enable-features=VaapiVideoDecoder,VaapiVideoEncoder "
