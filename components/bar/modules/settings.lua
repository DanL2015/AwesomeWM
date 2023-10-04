local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

local function buttons()
	return gears.table.join(awful.button({}, 1, function()
		awesome.emit_signal("panel::toggle")
	end))
end

local function create_widget()
	local image = wibox.widget({
		image = beautiful.icon_chevron_down,
		widget = wibox.widget.imagebox,
	})

	image.state = true

	local widget = require("helpers.clickable_widget")(image)

	widget:buttons(buttons())

	local tooltip = awful.tooltip({
		objects = { widget },
		markup = "<b>Settings</b>",
	})

	awesome.connect_signal("panel::toggle", function()
		image.state = not image.state
		if image.state then
			image.image = beautiful.icon_chevron_down
		else
			image.image = beautiful.icon_chevron_up
		end
	end)

	return widget
end

return create_widget
