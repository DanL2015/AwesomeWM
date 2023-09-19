local naughty = require("naughty")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local ruled = require("ruled")
local bling = require("bling")

naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification({
		urgency = "critical",
		title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
		message = message,
	})
end)

-- Tags
tag.connect_signal("request::default_layouts", function()
	awful.layout.append_default_layouts({
		awful.layout.suit.tile,
		awful.layout.suit.floating,
		-- awful.layout.suit.tile.left,
		-- awful.layout.suit.tile.bottom,
		-- awful.layout.suit.tile.top,
		-- awful.layout.suit.fair,
		-- awful.layout.suit.fair.horizontal,
		awful.layout.suit.spiral,
		awful.layout.suit.spiral.dwindle,
		-- awful.layout.suit.max,
		-- awful.layout.suit.max.fullscreen,
		-- awful.layout.suit.magnifier,
		-- awful.layout.suit.corner.nw,
	})
end)

awful.screen.connect_for_each_screen(function(s)
	awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[1])
end)

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	if not awesome.startup then
		awful.client.setslave(c)
	end

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Titlebars
client.connect_signal("request::titlebars", function(c)
	-- buttons for the titlebar
	local buttons = {
		awful.button({}, 1, function()
			c:activate({ context = "titlebar", action = "mouse_move" })
		end),
		awful.button({}, 3, function()
			c:activate({ context = "titlebar", action = "mouse_resize" })
		end),
	}

	awful.titlebar(c, { size = beautiful.titlebar_height }).widget = {
		{ --Left
			{
				{
					widget = wibox.container.margin(
						awful.titlebar.widget.iconwidget(c),
						beautiful.bmargin,
						beautiful.bmargin,
						beautiful.bmargin,
						beautiful.bmargin
					),
				},
				{
					halign = "left",
          valign = "center",
					-- widget = awful.titlebar.widget.titlewidget(c),
          markup = "<b>"..c.class:gsub("^%l", string.upper).."</b>",
          widget = wibox.widget.textbox,
					font = beautiful.font_small,
				},
				buttons = buttons,
        spacing = beautiful.xlarge_space,
				layout = wibox.layout.fixed.horizontal,
			},
			top = beautiful.xlarge_space,
			bottom = beautiful.xlarge_space,
			left = beautiful.xlarge_space,
			layout = wibox.container.margin,
		},
		nil,
		{ -- Right
			{
				{
					widget = wibox.container.margin(
						awful.titlebar.widget.minimizebutton(c),
						beautiful.bmargin,
						beautiful.bmargin,
						beautiful.bmargin,
						beautiful.bmargin
					),
				},
				{
					widget = wibox.container.margin(
						awful.titlebar.widget.maximizedbutton(c),
						beautiful.bmargin,
						beautiful.bmargin,
						beautiful.bmargin,
						beautiful.bmargin
					),
				},
				{
					widget = wibox.container.margin(
						awful.titlebar.widget.closebutton(c),
						beautiful.bmargin,
						beautiful.bmargin,
						beautiful.bmargin,
						beautiful.bmargin
					),
				},
				layout = wibox.layout.fixed.horizontal,
			},
			top = beautiful.xlarge_space,
			bottom = beautiful.xlarge_space,
			right = beautiful.xlarge_space,
			layout = wibox.container.margin,
		},
    expand = "none",
		layout = wibox.layout.align.horizontal,
	}
end)

-- Notifications
ruled.notification.connect_signal("request::rules", function()
	-- All notifications will match this rule.
	ruled.notification.append_rule({
		rule = {}, -- Match everything.
		properties = {
			screen = awful.screen.preferred,
			implicit_timeout = 5,
			widget_template = {
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
							{
								halign = "left",
								widget = naughty.widget.title,
                -- forced_width = beautiful.notification_text_width,
							},
							{
								halign = "left",
								widget = naughty.widget.message,
                -- forced_width = beautiful.notification_text_width,
							},
							layout = wibox.layout.fixed.vertical,
						},
						layout = wibox.layout.align.horizontal,
					},
					margins = beautiful.notification_padding,
					widget = wibox.container.margin,
				},
				id = "background_role",
				widget = naughty.container.background,
			},
		},
	})
end)

naughty.connect_signal("request::display", function(n)
	naughty.layout.box({ notification = n })
end)

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--    c:activate { context = "mouse_enter", raise = false }
-- end)

awesome.connect_signal("wallpaper::load", function()
	awful.spawn.easy_async_with_shell("cat ~/.cache/wal/wal", function(stdout)
		stdout = stdout:gsub("[\n\r]", "")
		bling.module.wallpaper.setup({
			screen = screen,
			position = "maximized",
			wallpaper = stdout,
		})
	end)
end)

awesome.emit_signal("wallpaper::load")
