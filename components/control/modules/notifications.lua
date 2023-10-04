local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local add_background = require("helpers.background_widget")

local function create_widget()
	local title = wibox.widget({
		markup = "<b>Notifications</b>",
		valign = "center",
		halign = "center",
		widget = wibox.widget.textbox,
	})

	local erase = wibox.widget({
		image = beautiful.icon_trash,
		forced_height = beautiful.notification_trash_size,
		forced_width = beautiful.notification_trash_size,
		widget = wibox.widget.imagebox,
	})

	local notifications = wibox.widget({
		spacing = beautiful.panel_internal_margin,
		layout = wibox.layout.overflow.vertical,
		forced_height = 600,
		scrollbar_width = 10,
		step = 50,
	})

	erase:buttons(awful.util.table.join(awful.button({}, 1, function()
		notifications:reset()
	end)))

	local widget = wibox.widget({
		{
			{
				nil,
				title,
				erase,
				layout = wibox.layout.align.horizontal,
			},
			notifications,
			spacing = beautiful.panel_internal_margin,
			layout = wibox.layout.fixed.vertical,
		},
		margins = beautiful.panel_internal_margin,
		layout = wibox.container.margin,
	})

	naughty.connect_signal("request::display", function(n)
		local notif_icon
		if n.clients[1] ~= nil then
			notif_icon = wibox.widget({
				client = n.clients[1],
				forced_height = beautiful.notification_icon_size,
				forced_width = beautiful.notification_icon_size,
				halign = "center",
				valign = "center",
				widget = awful.widget.clienticon,
			})
		else
			notif_icon = wibox.widget({
				image = n.app_icon or beautiful.icon_bell,
				resize = true,
				forced_height = beautiful.notification_icon_size,
				forced_width = beautiful.notification_icon_size,
				halign = "center",
				valign = "center",
				clip_shape = beautiful.rounded_rect(2),
				widget = wibox.widget.imagebox,
			})
		end

		local notif_image = wibox.widget({
			image = n.icon or beautiful.icon_bell,
			resize = true,
			forced_height = beautiful.notification_image_size,
			forced_width = beautiful.notification_image_size,
			halign = "right",
			valign = "center",
			clip_shape = beautiful.rounded_rect(4),
			widget = wibox.widget.imagebox,
		})

		local notif_time = wibox.widget({
			markup = os.date("%I:%M %p"),
			halign = "right",
			valign = "center",
			widget = wibox.widget.textbox,
		})

		local notif_app_name = wibox.widget({
			markup = "<b>" .. n.app_name .. "</b>",
			halign = "left",
			valign = "center",
			widget = wibox.widget.textbox,
		})

		local notif_title = wibox.widget({
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

		local notif_message = wibox.widget({
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

		local notif_actions = wibox.widget({
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
				shape = beautiful.rounded_rect(40),
				widget = wibox.container.background,
			},
			style = {
				underline_normal = false,
				underline_selected = true,
			},
			widget = naughty.list.actions,
		})

		local notif_template = add_background(wibox.widget({
			{
				{
					{
						notif_icon,
						right = beautiful.notification_inner_margin,
						left = beautiful.notification_inner_margin,
						layout = wibox.container.margin,
					},
					notif_app_name,
					notif_time,
					layout = wibox.layout.align.horizontal,
				},
				{
					{
						{
							{
								notif_title,
								notif_message,
								layout = wibox.layout.fixed.vertical,
							},
							margins = beautiful.notification_inner_margin,
							widget = wibox.container.margin,
						},
						{
							{
								notif_actions,
								shape = beautiful.rounded_rect(8),
								widget = wibox.container.background,
							},
							margins = beautiful.notification_inner_margin,
							layout = wibox.container.margin,
							visible = n.actions and #n.actions > 0,
						},
						layout = wibox.layout.fixed.vertical,
					},
					{
						notif_image,
						margins = beautiful.notification_inner_margin,
						layout = wibox.container.margin,
					},
					fill_space = true,
					spacing = beautiful.notification_inner_margin,
					layout = wibox.layout.fixed.horizontal,
				},
				layout = wibox.layout.fixed.vertical,
			},
			forced_height = beautiful.notification_height,
			margins = beautiful.notification_padding,
			widget = wibox.container.margin,
		}), 0, 0)

		notifications:insert(1, notif_template)

		notif_template:buttons(awful.util.table.join(awful.button({}, 1, function()
			notifications:remove_widgets(notif_template, true)
		end)))
	end)

	return widget
end

return create_widget
