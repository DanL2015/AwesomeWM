local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

local update_interval = 5
local bat_name = "BAT0"
local bat_script = "cat /sys/class/power_supply/" ..
    bat_name .. "/status && cat /sys/class/power_supply/" .. bat_name .. "/capacity"

local function update_battery()
    awful.spawn.easy_async_with_shell(bat_script, function(stdout)
        local status = {}
        local i = 1
        for w in stdout:gmatch("%S+") do
            status[i] = w
            i = i + 1
        end

        awesome.emit_signal("daemon::battery::status", status)
    end)
end

gears.timer {
    timeout = update_interval,
    autostart = true,
    call_now = true,
    callback = update_battery
}
