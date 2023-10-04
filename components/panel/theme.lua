local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")
local add_background = require("components.panel.add_background")
local create_small_button = require("components.panel.small_button_widget")
local apply_theme = require("themes")

local function create_widget()
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
        awesome.emit_signal("theme::wallpaper")
        apply_theme()
			end
		)
	end)

	return theme
end

return create_widget
