local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

local function next()
    awful.spawn.with_shell("playerctl next")
end

local function prev()
    awful.spawn.with_shell("playerctl previous")
end

local function toggle()
    awful.spawn.with_shell("playerctl play-pause")
end

local function update_toggle()
    awful.spawn.with_line_callback("playerctl -F status", {stdout = function(stdout)
        stdout = stdout:gsub("[\n\r]", "")
        if stdout == "Playing" then
            awesome.emit_signal("playerctl::toggle::status", true)
        else
            awesome.emit_signal("playerctl::toggle::status", false)
        end
    end})
end

local function update_metadata()
    awful.spawn.with_line_callback("playerctl -F metadata --format 'title_{{title}}artist_{{artist}}art_url_{{mpris:artUrl}}player_name_{{playerName}}album_{{album}}'", {stdout=function(stdout)
            local title = gears.string.xml_escape(stdout:match('title_(.*)artist_')) or ""
            local artist = gears.string.xml_escape(stdout:match('artist_(.*)art_url_')) or ""
            local art_url = stdout:match('art_url_(.*)player_name_') or ""
            local player_name = stdout:match('player_name_(.*)album_') or ""
            local album = gears.string.xml_escape(stdout:match('album_(.*)')) or ""

            art_url = art_url:gsub('%\n', '')
            if player_name == "spotify" then
                art_url = art_url:gsub("open.spotify.com", "i.scdn.co")
            end
            local art_path = ""
            if art_url ~= nil then
                art_path = os.tmpname()
                awful.spawn.easy_async_with_shell("curl -L -s " .. art_url .. " -o " .. art_path, function()
                    awesome.emit_signal("playerctl::metadata::status", title, artist, art_path, album)
                end)
            else
                awesome.emit_signal("playerctl::metadata::status", title, artist, art_path, album)
            end
    end})
end

update_toggle()
update_metadata()

awesome.connect_signal("playerctl::next", function()
    next()
end)

awesome.connect_signal("playerctl::prev", function()
    prev()
end)

awesome.connect_signal("playerctl::toggle", function()
    toggle()
end)