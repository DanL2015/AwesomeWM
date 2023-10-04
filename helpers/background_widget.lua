local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")

local function create_widget(widget, hspace, vspace)
	hspace = hspace or beautiful.xlarge_space
	vspace = vspace or beautiful.small_space
  local background = wibox.widget({
			{
				widget,
				layout = wibox.container.margin,
			},
			layout = wibox.container.background,
			bg = beautiful.bg1,
			shape = beautiful.rounded_rect(8),
  })
	local widget = wibox.widget({
		background,
		layout = wibox.container.margin,
		left = hspace,
		right = hspace,
		top = vspace,
		bottom = vspace,
	})
  
  awesome.connect_signal("theme::reload", function()
    background.bg = beautiful.bg1
  end)

	return widget
end

return create_widget
