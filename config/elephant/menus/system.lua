Name = "system"
NamePretty = "System"
Icon = "system-shutdown"
Terminal = false
Cache = false

Action = "%VALUE%"

function GetEntries()
    return {
        {
            Text = "Power Off",
            Value = "systemctl poweroff",
            Icon = "system-shutdown-symbolic",
        },
        {
            Text = "Reboot",
            Value = "systemctl reboot",
            Icon = "system-reboot-symbolic",
        },
        {
            Text = "Suspend",
            Value = "systemctl suspend",
            Icon = "system-suspend-symbolic",
        },
        {
            Text = "Log Out",
            Value = "hyprctl dispatch 'hl.dsp.exit()'",
            Icon = "system-log-out-symbolic",
        }
    }
end
