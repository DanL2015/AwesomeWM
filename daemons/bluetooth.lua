local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

local update_interval = 2
local bluetooth_script = "rfkill | grep bluetooth | awk '{ print $4 == \"unblocked\" }'"

local function update_bluetooth()
    awful.spawn.easy_async_with_shell(bluetooth_script, function(stdout)
        awesome.emit_signal("daemon::bluetooth::status", stdout:gsub("[\n\r]", ""))
    end)
end

gears.timer {
    timeout = update_interval,
    autostart = true,
    call_now = true,
    callback = update_bluetooth
}
