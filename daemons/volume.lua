local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

local update_interval = 5
local volume_script = "pamixer --get-volume"
local mute_script = "pamixer --get-mute"

local function update_volume()
	awful.spawn.easy_async_with_shell(volume_script, function(stdout)
		if stdout and tonumber(stdout) ~= nil then
			awesome.emit_signal("daemon::volume::status", tonumber(stdout))
		end
	end)
end

local function update_mute()
	awful.spawn.easy_async_with_shell(mute_script, function(stdout)
		if stdout then
			awesome.emit_signal("daemon::mute::status", stdout:gsub("[\n\r]", ""))
		end
	end)
end

awesome.connect_signal("daemon::volume::update", function(i)
	if i and tonumber(i) ~= nil then
		awful.spawn.with_shell("pamixer --set-volume " .. tostring(i), function()
			awesome.emit_signal("daemon::volume::status", tonumber(i))
		end)
	else
		update_volume()
	end
  update_mute()
end)

gears.timer({
	timeout = update_interval,
	autostart = true,
	call_now = true,
	callback = function()
    update_volume()
    update_mute()
  end,
})
