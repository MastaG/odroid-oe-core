FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

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


GN_ARGS += " \
 enable_hangout_services_extension=true \
 enable_widevine=true \
"

CHROMIUM_EXTRA_ARGS_append = " --ignore-gpu-blocklist --enable-native-gpu-memory-buffers --enable-zero-copy --num-raster-threads=4 --audio-buffer-size=4096"
