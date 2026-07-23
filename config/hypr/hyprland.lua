local colors = require("colors")
require("monitors")
require("default_apps")
require("env")

-- Split monitor workspaces
package.path = package.path .. ";./?.lua;./?/init.lua"
local smw = require("plugins.split-monitor-workspaces")


-- ENVIRONMENT VARIABLES

hl.env("PATH", os.getenv("HOME") .. "/.local/bin:" .. os.getenv("PATH"))
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("SSH_AUTH_SOCK", os.getenv("XDG_RUNTIME_DIR") .. "/gcr/ssh")


-- Ghostty dead keys
-- https://github.com/ghostty-org/ghostty/discussions/8899#discussioncomment-14717979
hl.env("GTK_IM_MODULE", "simple")


-- MY PROGRAMS

local terminal = "ghostty"
local fileManager = "nautilus --new-window"
local menu = "walker"
local browser = "zen-browser"
local osd = "swayosd-client --monitor " .. os.getenv("MAIN_MONITOR")
local colorPicker = "hyprpicker -a"

-- Quickshell
local lock = "qs ipc call lockscreen lock"
local controlCenter = "qs ipc call controlCenter toggle"


-- AUTOSTART

hl.on("hyprland.start", function()
    -- UI
    hl.exec_cmd("quickshell")  -- Shell
    hl.exec_cmd("awww-daemon") -- Wallpaper
    hl.exec_cmd("sunsetr")     -- Night light

    -- Helpers
    hl.exec_cmd("elephant")
    hl.exec_cmd("walker --gapplication-service")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("swayosd-server")
    hl.exec_cmd("playerctld daemon")

    -- Update notifier
    hl.exec_cmd("update-notifier")

    -- Keyring
    -- https://wiki.archlinux.org/title/GNOME/Keyring#Using_gnome-keyring-daemon_outside_desktop_environments_(KDE,_GNOME,_XFCE,_...)
    hl.exec_cmd("dbus-update-activation-environment DISPLAY XAUTHORITY WAYLAND_DISPLAY")
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
end)


-- LOOK AND FEEL

hl.config({
    general = {
        gaps_in = 4,
        gaps_out = 16,

        border_size = 2,

        col = {
            active_border = colors.primary,
            inactive_border = colors.surface_bright
        },

        resize_on_border = true
    },

    decoration = {
        rounding = 12,

        shadow = {
            range = 24,
            render_power = 2,
            color = "rgba(00000050)",
            color_inactive = "rgba(00000040)",
            offset = { 0, 2 }
        },

        blur = {
            size = 3,
            passes = 3
        }
    },

    animations = {
        enabled = true
    }
})

-- Default curves
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Springs
hl.curve("easy", { type = "spring", mass = 1, stiffness = 520, dampening = 38 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, bezier = "easeOutQuint", style = "slidevert" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

hl.config({
    dwindle = {
        preserve_split = true
    }
})

hl.config({
    misc = {
        focus_on_activate = true
    }
})


-- INPUT

hl.config({
    input = {
        -- Keyboard
        kb_layout = "se",

        -- Mouse
        follow_mouse = 2,
        float_switch_override_focus = 0,

        touchpad = {
            natural_scroll = true
        }
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})


-- KEYBINDINGS

local mainMod = "SUPER"

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd(browser .. " --private-window"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(lock))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd(colorPicker))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(menu .. " --provider menus:wallpapers"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(menu .. " --provider clipboard"))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd(menu .. " --provider menus:system"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(controlCenter))

-- Screenshot
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("screenshot"))                -- Region
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("screenshot output")) -- Monitor
hl.bind(mainMod .. " + ALT + P", hl.dsp.exec_cmd("screenshot window"))   -- Window

-- Scratchpad
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(mainMod .. " + SHIFT + S", function()
    local active = hl.get_active_window()

    if not active then
        return
    end

    if active.workspace.name == "special:scratchpad" then
        hl.dispatch(hl.dsp.window.move({ workspace = "+0" }))
    else
        hl.dispatch(hl.dsp.window.move({ workspace = "special:scratchpad" }))
    end
end)

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + up", function()
    hl.dispatch(hl.dsp.focus({ direction = "up" }))
    hl.dispatch(hl.dsp.window.bring_to_top())
end)
hl.bind(mainMod .. " + down", function()
    hl.dispatch(hl.dsp.focus({ direction = "down" }))
    hl.dispatch(hl.dsp.window.bring_to_top())
end)
hl.bind(mainMod .. " + left", function()
    hl.dispatch(hl.dsp.focus({ direction = "left" }))
    hl.dispatch(hl.dsp.window.bring_to_top())
end)
hl.bind(mainMod .. " + right", function()
    hl.dispatch(hl.dsp.focus({ direction = "right" }))
    hl.dispatch(hl.dsp.window.bring_to_top())
end)

-- Switch between tiled and floating layers with mainMod + Tab
hl.bind(mainMod .. " + TAB", function()
    local active = hl.get_active_window()

    if not active then
        return
    end

    if active.floating then
        hl.dispatch(hl.dsp.window.cycle_next({ tiled = true }))
    else
        hl.dispatch(hl.dsp.window.cycle_next({ floating = true }))
    end

    hl.dispatch(hl.dsp.window.bring_to_top())
end)

-- Swap windows with mainMod + SHIFT + arrow keys
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))

-- Switch workspaces with mainMod + [1-5]
hl.bind(mainMod .. " + 1", smw.workspace("1"))
hl.bind(mainMod .. " + 2", smw.workspace("2"))
hl.bind(mainMod .. " + 3", smw.workspace("3"))
hl.bind(mainMod .. " + 4", smw.workspace("4"))
hl.bind(mainMod .. " + 5", smw.workspace("5"))

-- Move active window to a workspace with mainMod + SHIFT + [1-5]
hl.bind(mainMod .. " + SHIFT + 1", smw.move_to_workspace("1"))
hl.bind(mainMod .. " + SHIFT + 2", smw.move_to_workspace("2"))
hl.bind(mainMod .. " + SHIFT + 3", smw.move_to_workspace("3"))
hl.bind(mainMod .. " + SHIFT + 4", smw.move_to_workspace("4"))
hl.bind(mainMod .. " + SHIFT + 5", smw.move_to_workspace("5"))

-- Switch next/prev workspace with mainMod + ALT + arrow keys
hl.bind(mainMod .. " + ALT + left", smw.workspace("-1"))
hl.bind(mainMod .. " + ALT + right", smw.workspace("+1"))

-- Move active window to next/prev workspace with mainMod + SHIFT + ALT + arrow keys
hl.bind(mainMod .. " + SHIFT + ALT + left", smw.move_to_workspace("-1"))
hl.bind(mainMod .. " + SHIFT + ALT + right", smw.move_to_workspace("+1"))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", smw.workspace("-1"))
hl.bind(mainMod .. " + mouse_up", smw.workspace("+1"))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Brightness controls
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(osd .. " --brightness raise"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(osd .. " --brightness lower"), { locked = true, repeating = true })

-- Volume controls
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(osd .. " --output-volume raise"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(osd .. " --output-volume lower"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(osd .. " --output-volume mute-toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(osd .. " --input-volume mute-toggle"), { locked = true, repeating = true })

-- Media controls
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("mediactl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("mediactl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("mediactl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("mediactl previous"), { locked = true })

hl.bind(mainMod .. " + Comma", hl.dsp.exec_cmd("mediactl previous"), { locked = true })
hl.bind(mainMod .. " + Period", hl.dsp.exec_cmd("mediactl play-pause"), { locked = true })
hl.bind(mainMod .. " + Minus", hl.dsp.exec_cmd("mediactl next"), { locked = true })

hl.bind(mainMod .. " + SHIFT + Comma", hl.dsp.exec_cmd("mediactl volume 0.05-"), { locked = true, repeating = true })
hl.bind(mainMod .. " + SHIFT + Minus", hl.dsp.exec_cmd("mediactl volume 0.05+"), { locked = true, repeating = true })

-- Caps lock
hl.bind("CAPS + Caps_Lock", hl.dsp.exec_cmd(osd .. " --caps-lock"))


-- WINDOWS AND WORKSPACES

hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize"
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name     = "fix-xwayland-drags",
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Float
hl.window_rule({
    match = { class = "org.gnome.Calculator" },
    float = true
})
hl.window_rule({
    match = { class = "steam", title = "Friends List" },
    float = true
})
hl.window_rule({
    match = { class = "xdg-desktop-portal-gtk" },
    float = true
})

-- Picture-in-Picture
hl.window_rule({
    match = { title = "Picture-in-Picture" },
    float = true,
    keep_aspect_ratio = true,
    decorate = false
})

-- Persistent size
hl.window_rule({
    match = { class = ".*" },
    persistent_size = true
})

-- Quickshell
hl.layer_rule({
    match = { namespace = "qs-control-center" },
    no_anim = true
})
hl.layer_rule({
    match = { namespace = "qs-notifications" },
    no_anim = true
})

-- Slurp fix
-- https://github.com/Gustash/Hyprshot/issues/60#issuecomment-3698826145
hl.layer_rule({
    match = { namespace = "selection" },
    no_anim = true
})


-- PLUGINS

smw.setup({
    workspace_count = 5,
    keep_focused = true,
    enable_wrapping = false
})
