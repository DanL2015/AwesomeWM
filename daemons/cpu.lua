local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

local M = {}

M.interval = 5
M.script = "top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\\([0-9.]*\\)%* id.*/\\1/' | awk '{print 100 - $1\"%\"}'"

function M.update()
    awful.spawn.easy_async_with_shell(M.script, function(stdout)
        stdout = stdout:gsub("[\n\r]", "")
        local cpu = tonumber(stdout:sub(1, -2))
        if cpu then
            awesome.emit_signal("cpu::update", math.floor(cpu))
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
end

M.start()
