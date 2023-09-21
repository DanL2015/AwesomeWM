local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")

local function add_background(widget)
	return wibox.widget({
		widget,
		bg = beautiful.panel_bg,
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, 8)
		end,
		border_color = beautiful.panel_border_color,
		border_width = beautiful.border_width,
		widget = wibox.container.background,
	})
end

return add_background
