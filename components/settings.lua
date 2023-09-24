local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local bling = require("bling")
local playerctl = bling.signal.playerctl.lib()
local add_background = require("components.add_background")

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

	local function create_small_button(image, command, description)
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
				margins = beautiful.panel_button_icon_padding,
				layout = wibox.container.margin,
			},
			fill_horizontal = false,
			fill_vertical = false,
			bg = beautiful.panel_button_active_bg,
			shape = function(cr, width, height)
				gears.shape.rounded_rect(cr, width, height, 8)
			end,
			layout = wibox.container.background,
		})
		background:buttons(buttons)
		local widget = wibox.widget({
			background,
			margins = beautiful.panel_internal_margin,
			layout = wibox.container.margin,
		})

		local tooltip = awful.tooltip({
			objects = { widget },
			markup = description,
		})
		return widget
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
		"awesome-client 'require(\"naughty\").suspend()'",
		"awesome-client 'require(\"naughty\").resume()'"
	)

	if naughty.is_suspended() then
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

	-- Weather widget
	local weather_icon = wibox.widget({
		image = beautiful.icon_sun,
		widget = wibox.widget.imagebox,
		forced_height = beautiful.panel_button_icon_size,
		forced_width = beautiful.panel_button_icon_size,
		align = "center",
		valign = "center",
	})

	local weather_temperature = wibox.widget({
		markup = "0",
		widget = wibox.widget.textbox,
	})

	local weather_description = wibox.widget({
		markup = "<b>Weather Unavailable</b>",
		widget = wibox.widget.textbox,
	})

	local weather = add_background(wibox.widget({
		{
			{
				weather_temperature,
				nil,
				{
					weather_icon,
					margins = beautiful.panel_internal_margin,
					layout = wibox.container.margin,
				},
				layout = wibox.layout.align.horizontal,
			},
			weather_description,
			layout = wibox.layout.flex.vertical,
		},
		margins = beautiful.panel_internal_margin,
		layout = wibox.container.margin,
	}))

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

	-- Media widget
	local art = wibox.widget({
		image = beautiful.icon_music,
		resize = true,
		align = "center",
		valign = "center",
		forced_height = beautiful.panel_art_size,
		forced_width = beautiful.panel_art_size,
		clip_shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, 8)
		end,
		widget = wibox.widget.imagebox,
	})

	local title_widget = wibox.widget({
		markup = "Playing",
		align = "left",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	local artist_widget = wibox.widget({
		markup = "Nothing",
		align = "left",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	local toggle_button = wibox.widget({
		image = beautiful.icon_play,
		widget = wibox.widget.imagebox,
		forced_height = beautiful.panel_button_icon_size,
		forced_width = beautiful.panel_button_icon_size,
		align = "center",
		valign = "center",
	})

	local prev_button = wibox.widget({
		image = beautiful.icon_skip_back,
		widget = wibox.widget.imagebox,
		forced_height = beautiful.panel_button_icon_size,
		forced_width = beautiful.panel_button_icon_size,
		align = "center",
		valign = "center",
	})

	local next_button = wibox.widget({
		image = beautiful.icon_skip_forward,
		widget = wibox.widget.imagebox,
		forced_height = beautiful.panel_button_icon_size,
		forced_width = beautiful.panel_button_icon_size,
		align = "center",
		valign = "center",
	})

	toggle_button:buttons(gears.table.join(awful.button({}, 1, function()
		playerctl:play_pause()
	end)))

	next_button:buttons(gears.table.join(awful.button({}, 1, function()
		playerctl:next()
	end)))

	prev_button:buttons(gears.table.join(awful.button({}, 1, function()
		playerctl:previous()
	end)))

	local media = add_background(wibox.widget({
		{
			{
				art,
				left = beautiful.panel_internal_margin,
				top = beautiful.panel_internal_margin,
				bottom = beautiful.panel_internal_margin,
				layout = wibox.container.margin,
			},
			{
				{
					{
						{
							layout = wibox.container.scroll.horizontal,
							step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
							fps = 60,
							speed = 75,
							artist_widget,
						},
						fg = beautiful.panel_fg,
						widget = wibox.container.background,
					},
					{
						{
							layout = wibox.container.scroll.horizontal,
							step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
							fps = 60,
							speed = 75,
							title_widget,
						},
						fg = beautiful.panel_fg,
						widget = wibox.container.background,
					},
					layout = wibox.layout.flex.vertical,
				},
				right = beautiful.panel_internal_margin,
				top = beautiful.panel_internal_margin,
				bottom = beautiful.panel_internal_margin,
				layout = wibox.container.margin,
			},
			{
				-- {
				-- {
				{
					{
						prev_button,
						margins = beautiful.medium_space,
						layout = wibox.container.margin,
					},
					{
						toggle_button,
						margins = beautiful.medium_space,
						layout = wibox.container.margin,
					},
					{
						next_button,
						margins = beautiful.medium_space,
						layout = wibox.container.margin,
					},
					layout = wibox.layout.flex.horizontal,
				},
				--      margins = beautiful.panel_internal_margin,
				--      layout = wibox.container.margin,
				--  },
				--  shape = function(cr, width, height)
				--      gears.shape.rounded_rect(cr, width, height, 8)
				--  end,
				--  bg = beautiful.panel_button_active_bg,
				--  layout = wibox.container.background,
				-- },
				margins = beautiful.panel_internal_margin,
				layout = wibox.container.margin,
			},
			layout = wibox.layout.align.horizontal,
		},
		margins = beautiful.panel_internal_margin,
		layout = wibox.container.margin,
	}))

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
	local power_widget = create_small_button(beautiful.icon_power, "systemctl hibernate", "Hibernate")

	local small_widgets = wibox.widget({
		{
			screenshot_full_widget,
			screenshot_select_widget,
			power_widget,
			spacing = beautiful.panel_internal_margin,
			layout = wibox.layout.flex.horizontal,
		},
		bg = beautiful.panel_widget_bg,
		shape = beautiful.rounded_rect(8),
		layout = wibox.container.background,
	})

	-- Theme switcher widget
	local theme_id = 0
	local theme_prev_button = create_small_button(
		beautiful.icon_chevron_left,
		"awesome-client 'awesome.emit_signal(\"theme::prev\")'",
		"Previous Background"
	)
	local theme_set_button = create_small_button(
		beautiful.icon_check,
		"awesome-client 'awesome.emit_signal(\"theme::set\")'",
		"Set Background"
	)
	local theme_next_button = create_small_button(
		beautiful.icon_chevron_right,
		"awesome-client 'awesome.emit_signal(\"theme::next\")'",
		"Next Background"
	)

	local theme_name = wibox.widget({
		halign = "left",
		valign = "top",
		markup = "Picture",
		widget = wibox.widget.textbox,
	})

	local theme_bg = wibox.widget({
		valign = "center",
		halign = "center",
		downscale = true,
		horizontal_fit_policy = "fit",
		vertical_fit_policy = "fit",
		forced_width = beautiful.panel_theme_bg_width,
		clip_shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, 10)
		end,
		widget = wibox.widget.imagebox,
	})

	local theme = add_background(wibox.widget({
		{
			theme_bg,
			{
				{
					theme_prev_button,
					theme_set_button,
					theme_next_button,
					layout = wibox.layout.fixed.horizontal,
				},
				halign = "center",
				valign = "bottom",
				layout = wibox.container.place,
			},
			{
				{
					add_background(wibox.widget({
						theme_name,
						margins = beautiful.xlarge_space,
						layout = wibox.container.margin,
					})),
					margins = beautiful.xlarge_space,
					layout = wibox.container.margin,
				},
				halign = "left",
				valign = "top",
				layout = wibox.container.place,
			},
			layout = wibox.layout.stack,
		},
		layout = wibox.container.margin,
	}))

	-- Control panel widget
	local control = wibox.widget({
		homogeneous = true,
		spacing = beautiful.panel_internal_margin,
		min_cols_size = 10,
		min_rows_size = 10,
		forced_num_rows = 22,
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
	control:add_widget_at(theme, 16, 1, 7, 6)

	awesome.connect_signal("theme::load", function()
		theme_bg.image = gears.surface.load_uncached(beautiful.backgrounds_path .. beautiful.backgrounds[theme_id])
		theme_name.markup = tostring(beautiful.backgrounds[theme_id])
	end)
	awesome.connect_signal("theme::prev", function()
		theme_id = theme_id - 1
		if theme_id < 0 then
			theme_id = theme_id + beautiful.background_num
		end
		theme_name.markup = tostring(beautiful.backgrounds[theme_id])
		awesome.emit_signal("theme::load")
	end)
	awesome.connect_signal("theme::next", function()
		theme_id = theme_id + 1
		if theme_id >= beautiful.background_num then
			theme_id = theme_id - beautiful.background_num
		end
		theme_name.markup = tostring(beautiful.backgrounds[theme_id])
		awesome.emit_signal("theme::load")
	end)
	awesome.connect_signal("theme::set", function()
		awful.spawn.easy_async_with_shell(
			"wal --cols16 -nq -i '" .. beautiful.backgrounds_path .. beautiful.backgrounds[theme_id] .. "'",
			function()
				awesome.restart()
			end
		)
	end)

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

	awesome.connect_signal("daemon::brightness::status", function(stdout)
		brightness_widget.value = stdout
	end)

	brightness_widget:connect_signal("property::value", function(_, new_value)
		brightness_text.markup = "<b>Brightness</b>: " .. tostring(new_value) .. "%"
		awesome.emit_signal("daemon::brightness::update", new_value)
	end)

	awesome.connect_signal("daemon::weather::status", function(temperature, description, icon_code)
		if description ~= nil and temperature ~= nil then
			weather_description.markup = "<b>" .. description .. "</b>"
			weather_temperature.markup = tostring(temperature) .. "°F"
		end

		if icon_code == "01" then
			weather_icon = beautiful.icon_sun
		elseif icon_code == "02" or icon_code == "03" or icon_code == "04" then
			weather_icon = beautiful.icon_cloud
		elseif icon_code == "09" then
			weather_icon = beautiful.icon_cloud_drizzle
		elseif icon_code == "10" then
			weather_icon = beautiful.icon_cloud_rain
		elseif icon_code == "11" then
			weather_icon = beautiful.icon_cloud_lightning
		elseif icon_code == "13" then
			weather_icon = beautiful.icon_cloud_snow
		elseif icon_code == "50" then
			weather_icon = beautiful.icon_wind
		end
	end)

	awesome.connect_signal("daemon::volume::status", function(stdout)
		volume_widget.value = stdout
	end)

	volume_widget:connect_signal("property::value", function(_, new_value)
		volume_text.markup = "<b>Volume</b>: " .. tostring(new_value) .. "%"
		awesome.emit_signal("daemon::volume::update", new_value)
	end)

	playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
		art:set_image(gears.surface.load_uncached(album_path))
		title_widget:set_markup_silently(title)
		artist_widget:set_markup_silently(artist)
	end)

	playerctl:connect_signal("playback_status", function(_, playing, player_name)
		if playing then
			toggle_button.image = beautiful.icon_pause
		else
			toggle_button.image = beautiful.icon_play
		end
	end)
	return control
end
return create_widget
