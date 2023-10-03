local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

local function buttons()
	return gears.table.join(awful.button({}, 1, function()
		awful.spawn(apps.network_manager, false)
	end))
end

local function update_widget(image, tooltip, res)
	local status = "<b>Unknown</b>"

	-- Edit Image
	if res == nil then
		image.image = beautiful.icon_wifi_off
		status = "<b>Unknown</b>"
	elseif res == "" then
		image.image = beautiful.icon_wifi_off
		status = "<b>Disconnected</b>"
	else
		image.image = beautiful.icon_wifi
		status = "<b>Connected</b>: " .. res
	end

	-- Edit Tooltip
	tooltip.markup = status
end

local function create_widget()
	local image = wibox.widget({
		image = beautiful.icon_wifi,
		widget = wibox.widget.imagebox,
	})

	local widget = require("widgets.clickable_widget")(image)

	widget:buttons(buttons())

	local tooltip = awful.tooltip({
		objects = { widget },
		markup = "",
	})

	awesome.connect_signal("daemon::wifi::status", function(res)
		update_widget(image, tooltip, res)
	end)

	return widget
end

return create_widget
