
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

local function update_widget(image, text, slider, res)
	local status = "<b>Volume</b>: "..tostring(res).."%"

	-- Edit Icon
	if not res or res == 0 then
		image.image = beautiful.icon_volume_x
		status = "<b>Muted</b>"
	elseif res < 20 then
		image.image = beautiful.icon_volume
	elseif res < 60 then
		image.image = beautiful.icon_volume_1
	else
		image.image = beautiful.icon_volume_2
	end

  text.markup = status
  slider.value = res
end

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

  -- slider:connect_signal("property::value", function(_, new_value)
	 --  text.markup = "<b>Volume</b>: " .. tostring(new_value) .. "%"
	 --  awful.spawn.with_shell("pamixer --set-volume " .. tostring(new_value))
  --   awesome.emit_signal("daemon::volume::update")
  -- end)

	return window
end

return create_widget
