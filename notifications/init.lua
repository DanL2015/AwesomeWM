local ruled = require("ruled")
local naughty = require("naughty")
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local rubato = require("rubato")

local function buttons(n)
	return gears.table.join(awful.button({}, 1, function()
		n:destroy(naughty.notification_closed_reason.dismissed_by_user)
	end))
end

-- Notifications
naughty.connect_signal("request::display", function(n)
	-- All notifications will match this rule.
	n.resident = true

	local timeout = 6

	local close_button = wibox.widget({
		valign = "center",
		halign = "right",
		forced_width = beautiful.notification_close_size,
		forced_height = beautiful.notification_close_size,
		image = beautiful.titlebar_close_button_focus,
		widget = wibox.widget.imagebox,
	})
  close_button:buttons(buttons(n))

	local title = wibox.widget({
		layout = wibox.container.scroll.horizontal,
		step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
		fps = 60,
		speed = 75,
		forced_width = beautiful.notification_text_width,
		{
			halign = "left",
			valign = "center",
			markup = "<b>" .. n.title .. "</b>",
			widget = wibox.widget.textbox,
		},
	})

	local message = wibox.widget({
		layout = wibox.container.scroll.horizontal,
		step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
		fps = 60,
		speed = 75,
		forced_width = beautiful.notification_text_width,
		{
			halign = "left",
			valign = "center",
			widget = naughty.widget.message,
		},
	})

	local app_name = wibox.widget({
		valign = "center",
		halign = "left",
		markup = "<b>" .. n.app_name .. "</b>",
		widget = wibox.widget.textbox,
	})

	local progressbar = wibox.widget({
		max_value = 1,
		forced_height = beautiful.notification_progress_height,
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, 8)
		end,
    color = beautiful.notification_progress_fg,
    background_color = beautiful.notification_progress_bg,
		widget = wibox.widget.progressbar,
	})

	local timed = rubato.timed({
		duration = timeout,
		intro = 0.1,
    pos = 0,
    rate = 20,
		clamp_position = true,
		subscribed = function(pos)
			progressbar:set_value(pos)
			if pos == 1 then
				n:destroy(naughty.notification_closed_reason.dismissed_by_user)
			end
		end,
	})

  timed.target = 1

	local widget = naughty.layout.box({
		notification = n,
		type = "notification",
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, 8)
		end,
		maximum_width = beautiful.notification_max_width,
		maximum_height = beautiful.notification_max_height,
		widget_template = {
			{
				{
					{
						app_name,
						close_button,
						layout = wibox.layout.flex.horizontal,
					},
					{
						{
							{
								{
									naughty.widget.icon,
									forced_height = beautiful.notification_icon_size,
									halign = "center",
									valign = "center",
									widget = wibox.container.place,
								},
								right = beautiful.notification_inner_margin,
								widget = wibox.container.margin,
							},
							nil,
							{
								title,
								message,
								layout = wibox.layout.fixed.vertical,
							},
							layout = wibox.layout.align.horizontal,
						},
						margins = beautiful.notification_inner_margin,
						widget = wibox.container.margin,
					},
					progressbar,
					layout = wibox.layout.fixed.vertical,
				},
				margins = beautiful.notification_padding,
				widget = wibox.container.margin,
			},
			id = "background_role",
			widget = naughty.container.background,
		},
	})

	widget.buttons = {}

  widget:connect_signal("mouse::enter", function()
    timed.pause = true
  end)

  widget:connect_signal("mouse::leave", function()
    timed.pause = false
  end)
end)
