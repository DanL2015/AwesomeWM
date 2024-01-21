local awful = require("awful")
local gears = require("gears")

local M = {}

M.interval = 5
M.script = "uptime -p"

function M.update()
    awful.spawn.easy_async_with_shell(M.script, function(stdout)
        awesome.emit_signal("uptime::update", stdout)
    end)
end

function M.start()
    gears.timer {
        timeout = M.interval,
        autostart = true,
        call_now = true,
        callback = M.update
    }
end

M.start()
