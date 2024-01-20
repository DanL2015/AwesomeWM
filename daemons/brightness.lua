local awful = require("awful")
local gears = require("gears")

local M = {}

M.interval = 5
M.script = "xbacklight -get"

function M.update()
    awful.spawn.easy_async_with_shell(M.script, function(stdout)
        stdout = stdout:gsub("[\n\r]", "")
        local bright = tonumber(stdout)
        if bright then
            awesome.emit_signal("brightness::update", bright)
        end
    end)
end

function M.start()
    gears.timer {
        timeout = M.interval,
        autostart = true,
        call_now = true,
        callback = M.update
    }

    awesome.connect_signal("brightness::increase", function(i)
        awful.spawn.with_shell("xbacklight -inc "..tostring(i))
        M.update()
    end)
    awesome.connect_signal("brightness::decrease", function(d)
        awful.spawn.with_shell("xbacklight -dec "..tostring(d))
        M.update()
    end)
end

M.start()
