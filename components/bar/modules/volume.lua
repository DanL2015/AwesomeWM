local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local helpers = require("helpers")

local function buttons()
	return gears.table.join(
		awful.button({}, 1, function()
			awful.spawn(apps.volume_manager, false)
		end),
		awful.button({}, 4, function()
			awful.spawn.with_shell("pamixer -i 5")
			awesome.emit_signal("daemon::volume::update")
		end),
		awful.button({}, 5, function()
			awful.spawn.with_shell("pamixer -d 5")
			awesome.emit_signal("daemon::volume::update")
		end)
	)
end

local function update_volume(image, tooltip, vol)
	if tooltip.mute == nil or tooltip.mute == "true" then
    return
	end

	vol = vol or 0
	local status = "<b>Volume</b>: " .. tostring(vol) .. "%"

	-- Edit Icon
	if not vol or vol == 0 then
		image.markup = "" 
	elseif vol < 20 then
		image.markup = ""
	elseif vol < 60 then
		image.markup = ""
	else
		image.markup = ""
	end

	-- Edit Tooltip
	tooltip.markup = status
end

local function update_mute(image, tooltip, mute)
	mute = mute or "false"
  tooltip.mute = mute
	-- Edit Icon
	if mute == "true" then
		image.image = beautiful.icon_volume_x
		tooltip.markup = "<b>Muted</b>"
  end
end

local function create_widget()
	local image = wibox.widget({
		markup = "",
		font = beautiful.font_icon,
		valign = "center",
		halign = "center",
		forced_width = beautiful.bar_button_size,
		forced_height = beautiful.bar_button_size,
		widget = wibox.widget.textbox,
	})

	local widget = require("helpers.clickable_widget")(image, image)

	widget:buttons(buttons())

	local tooltip = awful.tooltip({
		objects = { widget },
		markup = "",
	})

	awesome.connect_signal("daemon::volume::status", function(vol)
		update_volume(image, tooltip, vol)
	end)

	awesome.connect_signal("daemon::mute::status", function(mute)
		update_mute(image, tooltip, mute)
	end)

	return widget
end

return create_widget
