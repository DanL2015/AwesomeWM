local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local add_background = require("components.panel.add_background")

local function create_widget()
	-- Volume widget
	local volume_widget = wibox.widget({
		max_value = 100,
		bar_shape = gears.shape.rounded_bar,
		handle_shape = function(cr, width, height)
			gears.shape.circle(cr, width, height)
		end,
		widget = wibox.widget.slider,
	})

	local volume_text = wibox.widget({
		markup = "<b>Volume</b>",
		widget = wibox.widget.textbox,
	})

	local volume = add_background(wibox.widget({
		{
			{
				volume_text,
				margins = beautiful.panel_internal_margin,
				layout = wibox.container.margin,
			},
			volume_widget,
			layout = wibox.layout.align.vertical,
		},
		margins = beautiful.panel_internal_margin,
		layout = wibox.container.margin,
	}))

	awesome.connect_signal("daemon::volume::status", function(stdout)
		volume_widget.value = stdout
	end)

	volume_widget:connect_signal("property::value", function(_, new_value)
		volume_text.markup = "<b>Volume</b>: " .. tostring(new_value) .. "%"
		awesome.emit_signal("daemon::volume::update", new_value)
	end)

	awesome.connect_signal("theme::reload", function()
		volume_widget.handle_color = beautiful.slider_handle_color
		volume_widget.bar_active_color = beautiful.slider_bar_active_color
		volume_widget.bar_color = beautiful.slider_bar_color
	end)

	return volume
end

return create_widget
