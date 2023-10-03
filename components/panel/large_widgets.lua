local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local gears = require("gears")
local add_background = require("components.panel.add_background")

local function create_widget()
	local function create_large_button(image, text, on_command, off_command)
		local icon = wibox.widget({
			image = image,
			widget = wibox.widget.imagebox,
			resize = true,
			halign = "center",
			valign = "center",
			forced_height = beautiful.panel_button_icon_size,
			forced_width = beautiful.panel_button_icon_size,
		})
		local text = wibox.widget({
			markup = text,
			widget = wibox.widget.textbox,
		})

		local description = wibox.widget({
			markup = "Off",
			widget = wibox.widget.textbox,
		})

		local background = wibox.widget({
			{
				icon,
				margins = beautiful.panel_button_icon_padding,
				layout = wibox.container.margin,
			},
			bg = beautiful.panel_button_active_bg,
			shape = function(cr, width, height)
				gears.shape.rounded_rect(cr, width, height, 8)
			end,
			layout = wibox.container.background,
		})

		local button = wibox.widget({
			{
				background,
				margins = beautiful.panel_internal_margin,
				layout = wibox.container.margin,
			},
			{
				{
					text,
					nil,
					description,
					layout = wibox.layout.align.vertical,
				},
				margins = beautiful.panel_internal_margin,
				layout = wibox.container.margin,
			},
			nil,
			extend = "none",
			layout = wibox.layout.align.horizontal,
		})

		local buttons = gears.table.join(awful.button({}, 1, function()
			if button.on then
				button.on = false
				awful.spawn.with_shell(off_command)
				background.bg = beautiful.panel_button_inactive_bg
				description.markup = "Off"
			else
				button.on = true
				awful.spawn.with_shell(on_command)
				background.bg = beautiful.panel_button_active_bg
				description.markup = "On"
			end
		end))

		background:buttons(buttons)

		return {
			icon = icon,
			text = text,
			description = description,
			button = button,
			background = background,
		}
	end

	-- Left widgets
	local wifi = create_large_button(beautiful.icon_wifi, "<b>Network</b>", "rfkill unblock wifi", "rfkill block wifi")
	local bluetooth = create_large_button(
		beautiful.icon_bluetooth,
		"<b>Bluetooth</b>",
		"rfkill unblock bluetooth",
		"rfkill block bluetooth"
	)
	local alerts = create_large_button(
		beautiful.icon_bell,
		"<b>Alerts</b>",
		"awesome-client 'require(\"naughty\").suspended=false'",
		"awesome-client 'require(\"naughty\").suspended=true'"
	)

	if naughty.suspended then
		alerts.description.markup = "Off"
		alerts.button.on = false
	else
		alerts.description.markup = "On"
		alerts.button.on = true
	end

	local left_buttons_widget = add_background(wibox.widget({
		wifi.button,
		bluetooth.button,
		alerts.button,
		layout = wibox.layout.flex.vertical,
	}))

	awesome.connect_signal("daemon::wifi::status", function(stdout)
		if stdout ~= nil and stdout ~= "" then
			wifi.background.bg = beautiful.panel_button_active_bg
			wifi.description.markup = stdout
			wifi.button.on = true
		else
			wifi.background.bg = beautiful.panel_button_inactive_bg
			wifi.description.markup = "Off"
			wifi.button.on = false
		end
	end)

	awesome.connect_signal("daemon::bluetooth::status", function(stdout)
		if stdout == "1" then
			bluetooth.description.markup = "On"
			bluetooth.background.bg = beautiful.panel_button_active_bg
			bluetooth.button.on = true
		else
			bluetooth.description.markup = "Off"
			bluetooth.background.bg = beautiful.panel_button_inactive_bg
			bluetooth.button.on = false
		end
	end)
	return left_buttons_widget
end

return create_widget
