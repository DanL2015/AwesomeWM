local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local add_background = require("components.panel.add_background")

local function create_widget()
	-- Brightness widget
	local brightness_widget = wibox.widget({
		max_value = 100,
		bar_shape = gears.shape.rounded_bar,
		handle_shape = function(cr, width, height)
			gears.shape.circle(cr, width, height)
		end,
		widget = wibox.widget.slider,
	})

	local brightness_text = wibox.widget({
		markup = "<b>Brightness</b>",
		widget = wibox.widget.textbox,
	})

	local brightness = add_background(wibox.widget({
		{
			{
				brightness_text,
				margins = beautiful.panel_internal_margin,
				layout = wibox.container.margin,
			},
			brightness_widget,
			layout = wibox.layout.align.vertical,
		},
		margins = beautiful.panel_internal_margin,
		layout = wibox.container.margin,
	}))
	awesome.connect_signal("daemon::brightness::status", function(stdout)
		brightness_widget.value = stdout
	end)

	brightness_widget:connect_signal("property::value", function(_, new_value)
		brightness_text.markup = "<b>Brightness</b>: " .. tostring(new_value) .. "%"
		awesome.emit_signal("daemon::brightness::update", new_value)
	end)

	awesome.connect_signal("theme::reload", function()
    brightness_widget.handle_color = beautiful.slider_handle_color
	  brightness_widget.bar_active_color = beautiful.slider_bar_active_color
	  brightness_widget.bar_color = beautiful.slider_bar_color
  end)

	return brightness
end

return create_widget
