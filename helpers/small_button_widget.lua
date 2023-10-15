local naughty = require("naughty")
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

local function create_small_button(image, command, description, padding, margin)
	padding = padding or beautiful.panel_button_icon_padding
	margin = margin or beautiful.panel_internal_margin
	local icon = wibox.widget({
		image = image,
		widget = wibox.widget.imagebox,
		forced_height = beautiful.panel_button_icon_size,
		forced_width = beautiful.panel_button_icon_size,
		resize = true,
		halign = "center",
		valign = "center",
	})
	local buttons = gears.table.join(awful.button({}, 1, function()
		awful.spawn.with_shell(command)
	end))
	local background = wibox.widget({
		{
			icon,
			margins = padding,
			layout = wibox.container.margin,
		},
		fill_horizontal = false,
		fill_vertical = false,
		bg = beautiful.panel_button_active_bg,
		shape = helpers.rounded_rect(8),
		layout = wibox.container.background,
	})
	background:buttons(buttons)

	local widget = wibox.widget({
		background,
		margins = margin,
		layout = wibox.container.margin,
	})

	local tooltip = awful.tooltip({
		objects = { widget },
		markup = description,
	})
  
  awesome.connect_signal("theme::reload", function()
    background.bg = beautiful.panel_button_active_bg
  end)

	return widget
end

return create_small_button
