local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local title = require("components.notifications.modules.title")()
local notifs = require("components.notifications.modules.notifications")()
local background = require("components.notifications.modules.background")()

-- notifications panel widget
local notifications = wibox.widget({
    homogeneous = true,
    spacing = beautiful.panel_internal_margin,
    min_cols_size = 10,
    min_rows_size = 10,
    forced_num_rows = 4,
    forced_num_cols = 1,
    expand = true,
    layout = wibox.layout.grid
})

notifications:add_widget_at(notifs, 1, 1, 4, 1)
local panel_widget = wibox.widget({
    {
        {
            title,
            notifications,
            spacing = beautiful.panel_internal_margin,
            layout = wibox.layout.fixed.vertical
        },
        margins = beautiful.panel_internal_margin,
        layout = wibox.container.margin
    },
    bg = beautiful.panel_bg,
    shape = beautiful.rounded_rect(8),
    border_color = beautiful.panel_border_color,
    border_width = beautiful.border_width,
    widget = wibox.container.background
})

local panel = wibox({
    width = beautiful.panel_minimize_width,
    height = beautiful.panel_minimize_height,
    widget = panel_widget,
    ontop = true
})

awesome.connect_signal("panel::control::set", function(on)
    if on then
        notifications:reset()
        notifications:add_widget_at(notifs, 1, 1, 4, 1)
    else
        notifications:reset()
        notifications:add_widget_at(notifs, 1, 1, 3, 1)
        notifications:add_widget_at(background, 4, 1, 1, 1)
    end
end)

awesome.connect_signal("theme::reload", function()
    panel_widget.bg = beautiful.panel_bg
    panel_widget.border_color = beautiful.panel_border_color
end)

return {notifications, panel}
