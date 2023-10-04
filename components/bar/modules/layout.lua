local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local function create_widget(s)
	local layout_box = awful.widget.layoutbox({
		screen = s,
		-- Add buttons, allowing you to change the layout
		buttons = {
			awful.button({}, 1, function()
				awful.layout.inc(1)
			end),
			awful.button({}, 3, function()
				awful.layout.inc(-1)
			end),
			awful.button({}, 4, function()
				awful.layout.inc(1)
			end),
			awful.button({}, 5, function()
				awful.layout.inc(-1)
			end),
		},
	})

	local widget = require("helpers.clickable_widget")(layout_box)
	return widget
end
return create_widget
