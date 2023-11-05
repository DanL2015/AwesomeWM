local naughty = require("naughty")
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local bling = require("bling")
local helpers = require("helpers")
local cairo = require("lgi").cairo
local delayed_call = require("gears.timer").delayed_call

naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification({
        urgency = "critical",
        title = "An error occured" .. (startup and " during startup." or "."),
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
    minimizebutton.forced_height = beautiful.titlebar_button_size
    minimizebutton.forced_width = beautiful.titlebar_button_size
    minimizebutton.halign = "center"
    minimizebutton.valign = "center"
    local maximizebutton = awful.titlebar.widget.maximizedbutton(c)
    maximizebutton.forced_height = beautiful.titlebar_button_size
    maximizebutton.forced_width = beautiful.titlebar_button_size
    maximizebutton.halign = "center"
    maximizebutton.valign = "center"
    local closebutton = awful.titlebar.widget.closebutton(c)
    closebutton.forced_height = beautiful.titlebar_button_size
    closebutton.forced_width = beautiful.titlebar_button_size
    closebutton.halign = "center"
    closebutton.valign = "center"

    local left_widget = wibox.widget({
        {
            {
                awful.titlebar.widget.iconwidget(c),
                {
                    halign = "left",
                    valign = "center",
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
        shape = helpers.rounded_rect(),
        layout = wibox.container.background
    })

    local right_widget = wibox.widget({
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
        shape = helpers.rounded_rect(),
        layout = wibox.container.background
    })

    local titlebar_widget = wibox.widget({
        { -- Left
            left_widget,
            margins = beautiful.medium_space,
            layout = wibox.container.margin
        },
        nil,
        { -- Right
            right_widget,
            margins = beautiful.medium_space,
            layout = wibox.container.margin
        },
        layout = wibox.layout.align.horizontal
    })

    local titlebar = awful.titlebar(c, {
        size = beautiful.titlebar_height
    })

    titlebar.widget = titlebar_widget
end)

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--    c:activate { context = "mouse_enter", raise = false }
-- end)
