local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local helpers = require("helpers")

local function create_widget(widget, icon, hspace, vspace)
	hspace = hspace or beautiful.xlarge_space
	vspace = vspace or beautiful.xlarge_space
	local background = wibox.widget({
		widget = wibox.container.background,
		{
			layout = wibox.container.margin,
			left = hspace,
			right = hspace,
			top = vspace,
			bottom = vspace,
			widget,
		},
		shape = helpers.rounded_rect(),
	})

	background:connect_signal("mouse::enter", function()
		background.fg = beautiful.bg0
		background.bg = beautiful.clickable_active_bg
	end)

	background:connect_signal("mouse::leave", function()
		background.fg = beautiful.fg0
		background.bg = "#00000000"
	end)

	return background
end

return create_widget
