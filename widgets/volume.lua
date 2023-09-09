local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")

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

local function update_widget(image, tooltip, res)
	local status = "<b>Volume</b>: "..tostring(res).."%"

	-- Edit Icon
	if not res or res == 0 then
		image.image = beautiful.icon_volume_x
		status = "<b>Muted</b>"
	elseif res < 20 then
		image.image = beautiful.icon_volume
	elseif res < 60 then
		image.image = beautiful.icon_volume_1
	else
		image.image = beautiful.icon_volume_2
	end

	-- Edit Tooltip
	tooltip.markup = status
end

local function create_widget()
	local image = wibox.widget({
		image = beautiful.icon_volume,
		widget = wibox.widget.imagebox,
	})

	local widget = require("widgets.clickable_widget")(image)

	widget:buttons(buttons())

	local tooltip = awful.tooltip({
		objects = { widget },
		markup = "",
	})

	awesome.connect_signal("daemon::volume::status", function(...)
		update_widget(image, tooltip, ...)
	end)

	return widget
end

return create_widget
