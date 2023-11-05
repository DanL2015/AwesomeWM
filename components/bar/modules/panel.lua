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
		markup = "",
		font = beautiful.font_icon,
		forced_width = beautiful.bar_button_size,
		forced_height = beautiful.bar_button_size,
		halign = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	local widget = require("helpers.clickable_widget")(image, image)

	widget:buttons(buttons())

	local tooltip = awful.tooltip({
		objects = { widget },
		markup = "<b>Settings</b>",
	})

	return widget
end

return create_widget
