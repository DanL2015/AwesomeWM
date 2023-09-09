local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

local function update_widget(image, text, slider, res)
	text.markup = "<b>Brightness</b>: " .. res .. "%"
	slider.value = res
end

local function create_widget()
	local image = wibox.widget({
		image = beautiful.icon_sun,
		widget = wibox.widget.imagebox,
		resize = true,
		forced_height = beautiful.osd_image_height,
		foced_width = beautiful.osd_image_width,
		halign = "center",
		valign = "center",
	})

	local text = wibox.widget({
		markup = "<b>Brightness</b>: 0%",
		halign = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	local slider = wibox.widget({
		bar_shape = gears.shape.rounded_rect,
		bar_height = beautiful.osd_bar_height,
		bar_color = beautiful.osd_bar_color,
		bar_active_color = beautiful.osd_bar_active_color,
		handle_shape = gears.shape.circle,
    handle_width = beautiful.osd_bar_handle_width,
		handle_color = beautiful.osd_bar_handle_color,
    forced_height = beautiful.osd_bar_height,
		widget = wibox.widget.slider,
		minimum = 0,
		maximum = 100,
		value = 0,
	})

	local widget = wibox.widget({
		image,
		text,
		slider,
		layout = wibox.layout.align.vertical
	})

	local window = awful.popup({
		maximum_width = beautiful.osd_width,
		minimum_width = beautiful.osd_width,
		maximum_height = beautiful.osd_height,
		minimum_height = beautiful.osd_height,
		widget = wibox.widget({
			widget,
			margins = beautiful.osd_padding,
			layout = wibox.container.margin,
		}),
		bg = beautiful.osd_bg,
		ontop = true,
		visible = false,
    screen = screen[1],
		placement = function(c)
			awful.placement.bottom(c, { margins = { top = 0, bottom = beautiful.osd_margin, left = 0, right = 0 } })
		end,
	})

	awesome.connect_signal("daemon::brightness::status", function(...)
		update_widget(image, text, slider, ...)
	end)

  slider:connect_signal("property::value", function(_, new_value)
	  text.markup = "<b>Brightness</b>: " .. tostring(new_value) .. "%"
    awesome.emit_signal("daemon::brightness::update", new_value)
  end)

	return window
end

return create_widget
