local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local function create_widget()
	local left_buttons_widget = require("components.control.modules.large_widgets")()
	local small_widgets = require("components.control.modules.small_widgets")()
	local weather = require("components.control.modules.weather")()
	local brightness = require("components.control.modules.brightness")()
	local volume = require("components.control.modules.volume")()
	local media = require("components.control.modules.media")()
	local notifications = require("components.control.modules.notifications")()
	local theme = require("components.control.modules.theme")()

	-- Control panel widget
	local control = wibox.widget({
		homogeneous = true,
		spacing = beautiful.panel_internal_margin,
		min_cols_size = 10,
		min_rows_size = 10,
		forced_num_rows = 30,
		forced_num_cols = 6,
		expand = true,
		layout = wibox.layout.grid,
	})

	control:add_widget_at(left_buttons_widget, 1, 1, 6, 3)
	control:add_widget_at(small_widgets, 1, 4, 2, 3)
	control:add_widget_at(weather, 3, 4, 4, 3)
	control:add_widget_at(brightness, 7, 1, 3, 6)
	control:add_widget_at(volume, 10, 1, 3, 6)
	control:add_widget_at(media, 13, 1, 3, 6)
	control:add_widget_at(notifications, 16, 1, 8, 6)
	control:add_widget_at(theme, 24, 1, 7, 6)
	return control
end

-- settings panel widget
local settings = create_widget()
local panel = wibox({
    width = beautiful.panel_width,
    height = beautiful.panel_height,
    bg = beautiful.panel_bg,
    ontop = true,
})

panel:setup({
    {
        settings,
        margins = beautiful.panel_internal_margin,
        layout = wibox.container.margin,
    },
    bg = beautiful.panel_bg,
    shape = beautiful.rounded_rect(8),
    border_color = beautiful.panel_border_color,
    border_width = beautiful.border_width,
    widget = wibox.container.background,
})

-- Signals
awesome.connect_signal("panel::toggle", function()
    awful.placement.right(panel, {
        parent = awful.screen.focused(),
        margins = { right = beautiful.useless_gap },
    })
    panel.visible = not panel.visible
end)

awesome.connect_signal("theme::reload", function()
  panel.bg = beautiful.panel_bg
end)
