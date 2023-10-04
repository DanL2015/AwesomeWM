local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")

local function add_background(widget)
	local background = wibox.widget({
		widget,
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, 8)
		end,
		border_color = beautiful.panel_border_color,
		border_width = beautiful.border_width,
    bg = beautiful.panel_widget_bg,
		widget = wibox.container.background,
	})

	awesome.connect_signal("theme::reload", function()
    background.border_color = beautiful.panel_border_color
    background.bg = beautiful.panel_widget_bg
  end)

  return background
end

return add_background
