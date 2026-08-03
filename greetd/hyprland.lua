require("monitors")
require("env")

hl.on("hyprland.start", function()
    hl.exec_cmd("quickshell -p /var/lib/greetd/quickshell/greeter.qml && pkill hyprland")
end)

hl.config({
    input = {
        kb_layout = "se"
    },

    decoration = {
        blur = {
            enabled = false
        }
    },

    animations = {
        enabled = false
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        background_color = "0x000000",
        key_press_enables_dpms = true,
        mouse_move_enables_dpms = true
    }
})
