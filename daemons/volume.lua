local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

-- local update_interval = 1
local volume_script = "pamixer --get-volume"

local function update_volume()
	awful.spawn.easy_async_with_shell(volume_script, function(stdout)
		if stdout and tonumber(stdout) ~= nil then
			awesome.emit_signal("daemon::volume::status", tonumber(stdout))
		end
	end)
end

awesome.connect_signal("daemon::volume::update", function(i)
	if i and tonumber(i) ~= nil then
		awful.spawn.with_shell("pamixer --set-volume " .. tostring(i))
		awesome.emit_signal("daemon::volume::status", tonumber(i))
	else
		update_volume()
	end
end)

-- gears.timer({
-- 	timeout = update_interval,
-- 	autostart = true,
-- 	call_now = true,
-- 	callback = update_volume,
-- })

update_volume()
