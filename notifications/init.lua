local ruled = require("ruled")
local naughty = require("naughty")
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local rubato = require("rubato")
local helpers = require("helpers")

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

	local icon
	if n.clients[1] ~= nil then
		icon = wibox.widget({
			client = n.clients[1],
			forced_height = beautiful.notification_icon_size,
			forced_width = beautiful.notification_icon_size,
			widget = awful.widget.clienticon,
		})
	else
		icon = wibox.widget({
			image = n.app_icon or beautiful.icon_bell,
			resize = true,
			forced_height = beautiful.notification_icon_size,
			forced_width = beautiful.notification_icon_size,
			halign = "center",
			valign = "center",
			clip_shape = helpers.rounded_rect(2),
			widget = wibox.widget.imagebox,
		})
	end

	local image = wibox.widget({
		image = n.icon or beautiful.icon_bell,
		resize = true,
		forced_height = beautiful.notification_image_size,
		forced_width = beautiful.notification_image_size,
		halign = "right",
		valign = "center",
		clip_shape = helpers.rounded_rect(4),
		widget = wibox.widget.imagebox,
	})

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

	title:pause()

	local message = wibox.widget({
		layout = wibox.container.scroll.horizontal,
		step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
		fps = 60,
		speed = 75,
		forced_width = beautiful.notification_text_width,
		{
			halign = "left",
			valign = "center",
			markup = n.message,
			widget = wibox.widget.textbox,
		},
	})

	message:pause()

	local app_name = wibox.widget({
		valign = "center",
		halign = "left",
		markup = "<b>" .. n.app_name .. "</b>",
		widget = wibox.widget.textbox,
	})

	local progressbar = wibox.widget({
		max_value = 1,
    shape = helpers.rounded_rect(8),
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

	close_button:buttons(gears.table.join(awful.button({}, 1, function()
		n:destroy(naughty.notification_closed_reason.dismissed_by_user)
	end)))

	local actions = wibox.widget({
		notification = n,
		base_layout = wibox.widget({
			spacing = beautiful.xlarge_space,
			layout = wibox.layout.flex.horizontal,
		}),
		widget_template = {
			{
				{
					{
						id = "text_role",
						widget = wibox.widget.textbox,
					},
					left = beautiful.xlarge_space,
					right = beautiful.xlarge_space,
					widget = wibox.container.margin,
				},
				widget = wibox.container.place,
			},
			bg = beautiful.notification_action_bg,
			forced_height = beautiful.notification_action_height,
			forced_width = beautiful.notification_action_width,
			shape = helpers.rounded_rect(40),
			widget = wibox.container.background,
		},
		style = {
			underline_normal = false,
			underline_selected = true,
		},
		widget = naughty.list.actions,
	})

	local widget = naughty.layout.box({
		notification = n,
		type = "notification",
		shape = helpers.rounded_rect(8),
    maximum_width = beautiful.notification_max_width,
		maximum_height = beautiful.notification_max_height,
		widget_template = {
			{
				nil,
				{
					{
						{
							{
								icon,
								right = beautiful.notification_inner_margin,
								layout = wibox.container.margin,
							},
							app_name,
							close_button,
							layout = wibox.layout.align.horizontal,
						},
						{
							{
								{
									title,
									message,
									layout = wibox.layout.fixed.vertical,
								},
								{
									actions,
                  shape = helpers.rounded_rect(8),
									widget = wibox.container.background,
									visible = n.actions and #n.actions > 0,
								},
								spacing = beautiful.notification_inner_margin,
								layout = wibox.layout.fixed.vertical,
							},
							{
								image,
                margins = beautiful.notification_inner_margin,
                layout = wibox.container.margin,
							},
							fill_space = true,
							spacing = beautiful.notification_inner_margin,
							layout = wibox.layout.align.horizontal,
						},
						spacing = beautiful.large_space,
						layout = wibox.layout.fixed.vertical,
					},
					margins = beautiful.notification_padding,
					layout = wibox.container.margin,
				},
				{
					progressbar,
					direction = "east",
					forced_width = beautiful.notification_progress_width,
					forced_height = beautiful.notification_progress_height,
					layout = wibox.container.rotate,
				},
				layout = wibox.layout.align.horizontal,
			},
			id = "background_role",
			widget = naughty.container.background,
		},
	})

	widget.buttons = {}

	widget:connect_signal("mouse::enter", function()
		title:continue()
		message:continue()
		timed.pause = true
	end)

	widget:connect_signal("mouse::leave", function()
		title:pause()
		message:pause()
		timed.pause = false
	end)
end)
