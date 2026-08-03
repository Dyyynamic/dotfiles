-- Lock when lid is closed
hl.bind("switch:Lid Switch", hl.dsp.exec_cmd("qs ipc call lockscreen lockInstant"))
