local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

local function update_volume(image, text, slider, vol)
	vol = vol or 0
	slider.value = vol

	if text.mute == nil or text.mute == "true" then
		return
	end

	local status = "<b>Volume</b>: " .. tostring(vol) .. "%"

	-- Edit Icon
	if not vol or vol == 0 then
		image.image = beautiful.icon_volume_x
	elseif vol < 20 then
		image.image = beautiful.icon_volume
	elseif vol < 60 then
		image.image = beautiful.icon_volume_1
	else
		image.image = beautiful.icon_volume_2
	end

	text.markup = status
end

local function update_mute(image, text, slider, mute)
	mute = mute or "false"
	text.mute = mute
	-- Edit Icon
	if mute == "true" then
		image.image = beautiful.icon_volume_x
		text.markup = "<b>Muted</b>"
	end
end

local function create_widget()
	local image = wibox.widget({
		image = beautiful.icon_volume_1,
		widget = wibox.widget.imagebox,
		resize = true,
		forced_height = beautiful.osd_image_height,
		foced_width = beautiful.osd_image_width,
		halign = "center",
		valign = "center",
	})

	local text = wibox.widget({
		markup = "<b>Volume</b>: 0%",
		halign = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	local slider = wibox.widget({
		shape = gears.shape.rounded_rect,
		bar_shape = gears.shape.rounded_rect,
		bar_height = beautiful.osd_bar_height,
		background_color = beautiful.osd_bar_color,
		color = beautiful.osd_bar_active_color,
		forced_height = beautiful.osd_bar_height,
		widget = wibox.widget.progressbar,
		max_value = 100,
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
		border_color = beautiful.border_color_normal,
		border_width = beautiful.border_width,
		bg = beautiful.osd_bg,
		ontop = true,
		visible = false,
		screen = awful.screen.focused(),
		placement = function(c)
			awful.placement.bottom(c, { margins = { top = 0, bottom = beautiful.osd_margin, left = 0, right = 0 } })
		end,
	})

	awesome.connect_signal("daemon::volume::status", function(vol)
		update_volume(image, text, slider, vol)
	end)

	awesome.connect_signal("daemon::mute::status", function(mute)
		update_mute(image, text, slider, mute)
	end)

    awesome.connect_signal("theme::reload", function()
        slider.background_color = beautiful.osd_bar_color
        slider.color = beautiful.osd_bar_active_color
        window.border_color = beautiful.border_color_normal
		window.bg = beautiful.osd_bg
    end)

	return window
end

return create_widget
