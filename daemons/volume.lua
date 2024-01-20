local awful = require("awful")
local naughty = require("naughty")

local M = {}
M.mute = false
M.vol = 0

function M.update()
    awful.spawn.easy_async_with_shell("pamixer --get-mute && pamixer --get-volume", function(stdout)
        local info = {}
        for line in stdout:gmatch("[^\r\n]+") do
            table.insert(info, line)
        end
        if info[1] == "false" then
            M.mute = false
        else
            M.mute = true
        end
        M.vol = tonumber(info[2])
        awesome.emit_signal("volume::update", M.mute, M.vol)
    end)
end

function M.start()
    -- Initial values
    M.update()

    awful.spawn.easy_async({
        'pkill', '--full', '--uid', os.getenv('USER'), '^pactl subscribe'
    }, function()
        awful.spawn.with_line_callback([[
    bash -c "
    LANG=C pactl subscribe 2> /dev/null | grep --line-buffered \"Event 'change' on sink\"
    "]], {
            stdout = function(line) M.update() end
        })
    end)

    awesome.connect_signal("volume::increase", function(i)
        awful.spawn.with_shell("pamixer -i " .. tostring(i))
    end)

    awesome.connect_signal("volume::decrease", function(d)
        awful.spawn.with_shell("pamixer -d " .. tostring(d))
    end)

    awesome.connect_signal("volume::mute", function()
        awful.spawn.with_shell("pamixer -t")
    end)
end

M.start()
