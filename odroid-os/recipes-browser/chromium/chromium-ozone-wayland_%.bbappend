DEPENDS:append = " pipewire"

GN_ARGS:remove = "\
        use_gtk=false \
"

GN_ARGS:append = "\
        rtc_use_pipewire=true \
"
