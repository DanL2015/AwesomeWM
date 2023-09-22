local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local function create_widget()
	local systray = wibox.widget({
		-- base_size = beautiful.systray_icon_size,
		widget = wibox.widget.systray(),
	})

	local widget = wibox.widget({
		{
			shape = function(cr, width, height)
				gears.shape.rounded_rect(cr, width, height, 8)
			end,
			layout = wibox.container.background,
			{

				margins = beautiful.small_space,
				layout = wibox.container.margin,
				systray,
			},
		},
		margins = beautiful.small_space,
		layout = wibox.container.margin,
	})

	return widget
end

return create_widget
