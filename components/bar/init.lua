local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

awful.screen.connect_for_each_screen(function(s)
    local margins = beautiful.margins

    local bar = awful.wibar({
        screen = s,
        height = beautiful.bar_height,
        width = s.geometry.width - 2 * margins
    })

    awful.placement.top(bar, {
        margins = {
            top = margins,
            bottom = margins,
            left = margins,
            right = margins
        }
    })
    bar:struts({
        top = beautiful.bar_height + margins
    })

    bar:setup({
        {
            layout = wibox.layout.align.horizontal,
            expand = "none",
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                {
                    widget = require("components.bar.modules.launcher")()
                },
                {
                    widget = require("components.bar.modules.taglist")(s)
                }
            },
            {
                layout = wibox.layout.fixed.horizontal,
                {
                    widget = require("components.bar.modules.clock")
                }
            },
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                {
                    widget = require("components.bar.modules.systray")
                },
                require("helpers.background_widget")(wibox.widget({
                    {
                        widget = require("components.bar.modules.systray_button")(s)
                    },
                    {
                        widget = require("components.bar.modules.volume")
                    },
                    {
                        widget = require("components.bar.modules.wifi")
                    },
                    {
                        widget = require("components.bar.modules.panel")
                    },
                    layout = wibox.layout.fixed.horizontal
                })),
                require("helpers.background_widget")(require("components.bar.modules.battery")()),
                {
                    widget = require("components.bar.modules.layout")(s)
                }
            }
        },
        border_width = beautiful.border_width,
        border_color = beautiful.border_color_normal,
        bg = beautiful.bg0,
        layout = wibox.container.background
    })
end)
