local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

local M = {}

function M.update_toggle()
    awful.spawn.with_line_callback("playerctl -F status", {
        stdout = function(stdout)
            stdout = stdout:gsub("[\n\r]", "")
            if stdout == "Playing" then
                awesome.emit_signal("playerctl::toggle::update", true)
            else
                awesome.emit_signal("playerctl::toggle::update", false)
            end
        end
    })
end

function M.update_art()
    awful.spawn.with_line_callback(
        "playerctl -F metadata --format '{{mpris:artUrl}}'",
        {
            stdout = function(stdout)
                local art_url = stdout or ""

                art_url = art_url:gsub('%\n', '')
                art_url = art_url:gsub("open.spotify.com", "i.scdn.co")
                local art_path = ""
                if art_url ~= nil then
                    art_path = os.tmpname()
                    awful.spawn.easy_async_with_shell("curl -L -s " .. art_url .. " -o " .. art_path, function()
                        awesome.emit_signal("playerctl::art::update", art_path)
                    end)
                end
            end
        })
end

function M.update_metadata()
    awful.spawn.with_line_callback(
        "playerctl -F metadata --format 'title_{{title}}artist_{{artist}}player_name_{{playerName}}album_{{album}}'",
        {
            stdout = function(stdout)
                local title = gears.string.xml_escape(stdout:match('title_(.*)artist_')) or nil
                local artist = gears.string.xml_escape(stdout:match('artist_(.*)player_name_')) or nil
                local player_name = stdout:match('player_name_(.*)album_') or nil
                local album = gears.string.xml_escape(stdout:match('album_(.*)')) or nil
                awesome.emit_signal("playerctl::metadata::update", title, artist, player_name, album)
            end
        })
end

function M.start()
    awful.spawn.easy_async({ 'pkill', '--full', '--uid', os.getenv('USER'), '^playerctl -F' },
        function()
            M.update_toggle()
            M.update_art()
            M.update_metadata()
        end)

    awesome.connect_signal("playerctl::next", function()
        awful.spawn.with_shell("playerctl next")
    end)

    awesome.connect_signal("playerctl::prev", function()
        awful.spawn.with_shell("playerctl previous")
    end)

    awesome.connect_signal("playerctl::toggle", function()
        awful.spawn.with_shell("playerctl play-pause")
    end)
end

M.start()
