local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- settings panel widget
local current_panel = 0
local settings = require("components.settings")()
local notifications = require("components.notifications")()
local panel = wibox({
	width = beautiful.panel_width,
	height = beautiful.panel_height,
	bg = beautiful.panel_bg,
	ontop = true,
})

local function panel_setup(widget)
	panel:setup({
		{
			widget,
			margins = beautiful.panel_internal_margin,
			layout = wibox.container.margin,
		},
		bg = beautiful.panel_bg,
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, 8)
		end,
		border_color = beautiful.panel_border_color,
		border_width = beautiful.border_width,
		widget = wibox.container.background,
	})
end

-- Signals
awesome.connect_signal("panel::settings", function()
	if panel.visible and current_panel == 1 then
		panel.visible = false
	else
		if current_panel ~= 1 then
			current_panel = 1
      panel_setup(settings)
		end
		awful.placement.top_right(panel, {
			parent = awful.screen.focused(),
			margins = { top = beautiful.bar_height + beautiful.useless_gap, right = beautiful.useless_gap },
		})
		panel.visible = true
	end
end)

awesome.connect_signal("panel::notifications", function()
	if panel.visible and current_panel == 2 then
		panel.visible = false
	else
		if current_panel ~= 2 then
			current_panel = 2
      panel_setup(notifications)
		end
		awful.placement.top_right(panel, {
			parent = awful.screen.focused(),
			margins = { top = beautiful.bar_height + beautiful.useless_gap, right = beautiful.useless_gap },
		})
		panel.visible = true
	end
end)
