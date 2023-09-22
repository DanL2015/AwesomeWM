local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local add_background = require("components.add_background")

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
		layout = wibox.layout.fixed.vertical,
	})

	erase:buttons(awful.util.table.join(awful.button({}, 1, function()
		notifications:reset()
		collectgarbage("collect")
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
		local notif_image = n.icon or n.app_icon
		if not notif_image then
			notif_image = beautiful.icon_bell
		end

		local notif_icon = wibox.widget({
			image = notif_image,
			resize = "true",
			halign = "center",
			valign = "center",
			forced_height = beautiful.notification_icon_size,
			forced_width = beautiful.notification_icon_size,
      clip_shape = beautiful.rounded_rect(2),
			widget = wibox.widget.imagebox
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
			markup = "<b>" .. n.title .. "</b>",
			halign = "left",
			valign = "center",
			widget = wibox.widget.textbox,
		})

		local notif_message = wibox.widget({
			markup = n.message,
			halign = "left",
			valign = "center",
			widget = wibox.widget.textbox,
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
						notif_title,
						notif_message,
						layout = wibox.layout.fixed.vertical,
					},
					margins = beautiful.notification_inner_margin,
					widget = wibox.container.margin,
				},
				-- {
				-- 	{
				-- 		actions,
				-- 		shape = function(cr, width, height)
				-- 			gears.shape.rounded_rect(cr, width, height, 8)
				-- 		end,
				-- 		widget = wibox.container.background,
				-- 	},
				-- 	margins = beautiful.notification_inner_margin,
				-- 	layout = wibox.container.margin,
				-- 	visible = n.actions and #n.actions > 0,
				-- },
				layout = wibox.layout.fixed.vertical,
			},
			margins = beautiful.notification_padding,
			widget = wibox.container.margin,
		}))

		notifications:add(notif_template)

		notif_template:buttons(awful.util.table.join(awful.button({}, 1, function()
			notifications:remove_widgets(notif_template, true)
		end)))
	end)

	return widget
end

return create_widget
