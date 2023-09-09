local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

-- local update_interval = 5
local brightness_script = "xbacklight -get"

local function update_backlight()
	awful.spawn.easy_async_with_shell(brightness_script, function(stdout)
		if stdout and tonumber(stdout) ~= nil then
		  awesome.emit_signal("daemon::brightness::status", tonumber(stdout))
    end
	end)
end

awesome.connect_signal("daemon::brightness::update", function(i)
	if i and tonumber(i) ~= nil then
		awful.spawn.with_shell("xbacklight -set " .. tostring(i))
		awesome.emit_signal("daemon::brightness::status", tonumber(i))
	else
    update_backlight()
	end
end)

-- gears.timer({
-- 	timeout = update_interval,
-- 	autostart = true,
-- 	call_now = true,
-- 	callback = update_backlight,
-- })

update_backlight()
