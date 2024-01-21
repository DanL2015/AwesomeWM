local awful = require("awful")
local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")


local function create_bar(s)
    s.bar = awful.wibar({
        position = "left",
        width = beautiful.bar_width,
        screen = s,
        height = s.geometry.height
    })

    s.bar.widget = helpers.add_bg0(wibox.widget({
        layout = wibox.layout.align.vertical,
        { -- Top widgets
            -- Launcher, Taglist
            require("components.bar.modules.launcher")(),
            require("components.bar.modules.taglist")(s),
            spacing = beautiful.margin[1],
            layout = wibox.layout.fixed.vertical,
        },
        { -- Middle widgets
            -- Tasklist
            require("components.bar.modules.tasklist")(s),
            spacing = beautiful.margin[1],
            layout = wibox.layout.fixed.vertical
        },
        { -- Bottom widgets
            -- Systray, Wifi+Volume, Battery, Clock, Layout
            require("components.bar.modules.systray")(),
            require("components.bar.modules.volume")(),
            require("components.bar.modules.wifi")(),
            require("components.bar.modules.battery")(),
            require("components.bar.modules.clock")(),
            require("components.bar.modules.layout")(),
            spacing = beautiful.margin[1],
            layout = wibox.layout.fixed.vertical
        }
    }))
end

screen.connect_signal("request::desktop_decoration", function(s)
    create_bar(s)
end)
