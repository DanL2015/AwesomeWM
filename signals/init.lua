local naughty = require("naughty")
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local bling = require("bling")

naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification({
        urgency = "critical",
        title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
        message = message
    })
end)

-- Tags
tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({awful.layout.suit.tile, awful.layout.suit.floating,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
                                         awful.layout.suit.spiral, awful.layout.suit.spiral.dwindle -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    })
end)

awful.screen.connect_for_each_screen(function(s)
    awful.tag({"1", "2", "3", "4", "5"}, s, awful.layout.layouts[1])
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
    local buttons = {awful.button({}, 1, function()
        c:activate({
            context = "titlebar",
            action = "mouse_move"
        })
    end), awful.button({}, 3, function()
        c:activate({
            context = "titlebar",
            action = "mouse_resize"
        })
    end)}

    local minimizebutton = awful.titlebar.widget.minimizebutton(c)
    local maximizebutton = awful.titlebar.widget.maximizedbutton(c)
    local closebutton = awful.titlebar.widget.closebutton(c)

    awful.titlebar(c, {
        size = beautiful.titlebar_height
    }).widget = {
        { -- Left
            {
                {
                    {
                        awful.titlebar.widget.iconwidget(c),
                        {
                            halign = "left",
                            valign = "center",
                            -- widget = awful.titlebar.widget.titlewidget(c),
                            markup = "<b>" .. c.class:gsub("^%l", string.upper) .. "</b>",
                            widget = wibox.widget.textbox,
                            font = beautiful.font_small
                        },
                        buttons = buttons,
                        spacing = beautiful.xlarge_space,
                        layout = wibox.layout.fixed.horizontal
                    },
                    left = beautiful.xlarge_space,
                    top = beautiful.medium_space,
                    bottom = beautiful.medium_space,
                    right = beautiful.xlarge_space,
                    layout = wibox.container.margin
                },
                bg = beautiful.titlebar_button_bg,
                shape = function(cr, width, height)
                    gears.shape.rounded_rect(cr, width, height, 8)
                end,
                layout = wibox.container.background
            },
            margins = beautiful.medium_space,
            layout = wibox.container.margin
        },
        nil,
        { -- Right
            {
                {
                    {
                        minimizebutton,
                        maximizebutton,
                        closebutton,
                        spacing = beautiful.bmargin,
                        layout = wibox.layout.fixed.horizontal
                    },
                    margins = beautiful.medium_space,
                    layout = wibox.container.margin
                },
                bg = beautiful.titlebar_button_bg,
                shape = function(cr, width, height)
                    gears.shape.rounded_rect(cr, width, height, 8)
                end,
                layout = wibox.container.background
            },
            margins = beautiful.medium_space,
            layout = wibox.container.margin
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--    c:activate { context = "mouse_enter", raise = false }
-- end)

awesome.connect_signal("theme::wallpaper", function()
    awful.spawn.easy_async_with_shell("cat ~/.cache/wal/wal", function(stdout)
        stdout = stdout:gsub("[\n\r]", "")
        bling.module.wallpaper.setup({
            screen = screen,
            position = "maximized",
            wallpaper = stdout
        })
    end)
end)

screen.connect_signal('request::desktop_decoration', function(s)
    awesome.emit_signal("theme::wallpaper")
end)

awesome.emit_signal("theme::wallpaper")
