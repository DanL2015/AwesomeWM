local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

local update_interval = 2
local wifi_script = "nmcli -t -f active,ssid dev wifi | grep -E '^yes' | cut -d\\' -f2 | cut -b 5-"

local function update_wifi()
    awful.spawn.easy_async_with_shell(wifi_script, function(stdout)
        awesome.emit_signal("daemon::wifi::status", stdout:gsub("[\n\r]", ""))
    end)
end

gears.timer {
    timeout = update_interval,
    autostart = true,
    call_now = true,
    callback = update_wifi
}
