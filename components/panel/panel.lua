local wibox = require("wibox")
local beautiful = require("beautiful")

local function create_widget()
	local left_buttons_widget = require("components.panel.large_widgets")()
	local small_widgets = require("components.panel.small_widgets")()
	local weather = require("components.panel.weather")()
	local brightness = require("components.panel.brightness")()
	local volume = require("components.panel.volume")()
	local media = require("components.panel.media")()
	local notifications = require("components.panel.notifications")()
	local theme = require("components.panel.theme")()

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
return create_widget
