local awful = require("awful")
local gears = require("gears")

local M = {}

M.interval = 5
M.script = "free -m | grep Mem | awk '{print ($3/$2)*100}'"

function M.update()
    awful.spawn.easy_async_with_shell(M.script, function(stdout)
        local memory = tonumber(stdout)
        awesome.emit_signal("memory::update", math.floor(memory))
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
