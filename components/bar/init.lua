local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

awful.screen.connect_for_each_screen(function(s)
	local bar = awful.wibar({ position = "top", screen = s, bg = beautiful.bar_bg, height = beautiful.bar_height })
	bar:setup({
		layout = wibox.layout.align.horizontal,
		expand = "none",
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			{
				widget = require("components.bar.modules.launcher")(),
			},
			{
				widget = require("components.bar.modules.taglist")(s),
			},
		},
		{
			layout = wibox.layout.fixed.horizontal,
			{
				widget = require("components.bar.modules.clock"),
			},
		},
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			{
				widget = require("components.bar.modules.systray"),
			},
			require("helpers.background_widget")(wibox.widget({
				{
					widget = require("components.bar.modules.systray_button")(s),
				},
				{
					widget = require("components.bar.modules.volume"),
				},
				{
					widget = require("components.bar.modules.wifi"),
				},
				{
					widget = require("components.bar.modules.battery"),
				},
				{
					widget = require("components.bar.modules.panel"),
				},
				layout = wibox.layout.fixed.horizontal,
			})),
			{
				widget = require("components.bar.modules.layout")(s),
			},
		},
	})
	awesome.connect_signal("theme::reload", function()
		bar.bg = beautiful.bar_bg
	end)
end)
