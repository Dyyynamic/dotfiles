hl.on("hyprland.start", function()
    hl.exec_cmd("steam -silent")
    hl.exec_cmd("vesktop")
    hl.exec_cmd("spotify")
end)

-- Default workspaces
hl.window_rule({
    match = { class = "vesktop" },
    workspace = "6 silent"
})
hl.window_rule({
    match = { class = "Spotify" },
    workspace = "7 silent"
})

