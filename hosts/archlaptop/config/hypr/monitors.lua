hl.monitor({
    output = "eDP-1",
    mode = "1920x1080@60",
    position = "0x0",
    scale = 1
})

-- Lock when lid is closed
hl.bind("switch:Lid Switch", hl.dsp.exec_cmd("qs ipc call lockscreen lockInstant"))
