local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local function create_widget()
	local systray = wibox.widget({
		widget = wibox.widget.systray(),
	})

	local widget = wibox.widget({
		systray,
		margins = beautiful.large_space,
		layout = wibox.container.margin,
	})

	return widget
end

local systray = create_widget()

return systray
