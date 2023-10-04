local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")

local function create_widget(widget, hspace, vspace)
	hspace = hspace or beautiful.medium_space
	vspace = vspace or beautiful.medium_space
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
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, 4)
		end,
	})

	background:connect_signal("mouse::enter", function()
		background.bg = beautiful.clickable_active_bg
	end)

	background:connect_signal("mouse::leave", function()
		background.bg = "#00000000"
	end)

	awesome.connect_signal("theme::reload", function()
		background:connect_signal("mouse::enter", function()
			background.bg = beautiful.clickable_active_bg
		end)
	end)

	return background
end

return create_widget
