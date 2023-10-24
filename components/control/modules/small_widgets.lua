local wibox = require("wibox")
local beautiful = require("beautiful")
local create_small_button = require("helpers.small_button_widget")
local helpers = require("helpers")

local function create_widget()
	-- Small buttons
	local screenshot_full_widget = create_small_button(
		beautiful.icon_maximize,
		"maim | xclip -selection clipboard -t image/png",
		"Screenshot Fullscreen"
	)
	local screenshot_select_widget = create_small_button(
		beautiful.icon_minimize,
		"maim -su | xclip -selection clipboard -t image/png",
		"Screenshot Selected"
	)
	local power_widget = create_small_button(beautiful.icon_power, "awesome-client 'awesome.emit_signal(\"powermenu::toggle\")'", "Hibernate")

	local small_widgets = wibox.widget({
		{
			screenshot_full_widget,
			screenshot_select_widget,
			power_widget,
			spacing = beautiful.panel_internal_margin,
			layout = wibox.layout.flex.horizontal,
		},
		bg = beautiful.panel_widget_bg,
		shape = helpers.rounded_rect(8),
		layout = wibox.container.background,
	})

	return small_widgets
end

return create_widget
