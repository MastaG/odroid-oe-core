PACKAGECONFIG = "proprietary-codecs use-egl impl-side-painting use-linux-v4l2 cups component-build"

GN_ARGS += " \
 enable_hangout_services_extension=true \
 use_wayland_gbm=true \
"
