local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

awful.screen.connect_for_each_screen(function(s)
	s.bar = awful.wibar({ position = "top", screen = s, bg = beautiful.bar_bg, height = beautiful.bar_height })
	s.bar:setup({
		layout = wibox.layout.align.horizontal,
		expand = "none",
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			{
				widget = require("widgets.launcher")(),
			},
			{
				widget = require("widgets.taglist")(s),
			},
			-- {
			--     widget = require("widgets.activewindow")(),
			-- },
		},
		{
			layout = wibox.layout.fixed.horizontal,
			-- {
			--     widget = require("widgets.tasklist")(s),
			-- }
			{
				widget = require("widgets.clock"),
			},
		},
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			-- {
			--     widget = require("widgets.wifi")
			-- },
			-- {
			--     widget = require("widgets.search")
			-- },
			-- {
			--     widget = require("widgets.username")
			-- },
			{
				widget = require("widgets.systray"),
			},
			require("widgets.background_widget")(wibox.widget({
				{
					widget = require("widgets.volume"),
				},
				{
					widget = require("widgets.battery"),
				},
				{
					widget = require("widgets.panel"),
				},
				layout = wibox.layout.fixed.horizontal,
			})),
			{
				widget = require("widgets.layout")(s),
			},
		},
	})
end)
