GN_ARGS:remove = "\
        ozone_platform_x11=false \
"

GN_ARGS += "\
        ozone_platform_x11=true \
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
        libxshmfence \
        libxtst \
        libxkbcommon \
"

RDEPENDS:${PN} += "libx11-xcb"
REQUIRED_DISTRO_FEATURES += "x11"

PROVIDES = "chromium"

CHROMIUM_EXTRA_ARGS:append = " --enable-wayland-ime"
