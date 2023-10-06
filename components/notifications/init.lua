local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local title = require("components.notifications.modules.title")()
local notifs = require("components.notifications.modules.notifications")()

-- notifications panel widget
local notifications = wibox.widget({
    homogeneous = true,
    spacing = beautiful.panel_internal_margin,
    min_cols_size = 10,
    min_rows_size = 10,
    forced_num_rows = 0,
    forced_num_cols = 0,
    expand = true,
    layout = wibox.layout.grid
})

notifications:add_widget_at(notifs, 1, 1, 15, 6)

local panel = wibox({
    width = beautiful.panel_minimize_width,
    height = beautiful.panel_minimize_height,
    bg = beautiful.panel_bg,
    ontop = true
})

panel:setup({
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

return {notifications, panel}
