Name = "wallpapers"
NamePretty = "Wallpapers"
Icon = "preferences-desktop-wallpaper"
Terminal = false
Cache = false

Action = "matugen image '%VALUE%' --source-color-index 0"

local function generate_thumbnail(path, thumb_path)
    os.execute("magick '" .. path .. "' -thumbnail 500x500\\> '" .. thumb_path
        .. "' &")
end

function GetEntries()
    local entries = {}

    local wallpaper_dir = os.getenv("HOME") .. "/Pictures/Wallpapers"
    local cache_dir = os.getenv("HOME") .. "/.cache/elephant/wallpapers"

    os.execute("mkdir -p '" .. cache_dir .. "'")

    local handle = io.popen("find '" .. wallpaper_dir
        .. "' -maxdepth 1 -type f -not -name '.*'")

    if not handle then
        return entries
    end

    for file in handle:lines() do
        if file:match("%.png$") or file:match("%.jpg$")
            or file:match("%.jpeg$") then
            local name = file:match("[^/]+$")
            local name_no_ext = name:match("(.*)%..+$")
            local thumb = cache_dir .. "/" .. name_no_ext .. ".png"
            local thumb_exists = true

            local f = io.open(thumb)
            if not f then
                generate_thumbnail(file, thumb)
                thumb_exists = false
            else
                f:close()
            end

            table.insert(entries, {
                Text = name,
                Value = file,
                Icon = thumb_exists and thumb or "image-x-generic",
                Preview = thumb
            })
        end
    end

    handle:close()

    return entries
end
