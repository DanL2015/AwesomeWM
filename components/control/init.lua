local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local title = require("components.control.modules.title")()
local left_buttons_widget = require("components.control.modules.large_widgets")()
local small_widgets = require("components.control.modules.small_widgets")()
local weather = require("components.control.modules.weather")()
local brightness = require("components.control.modules.brightness")()
local volume = require("components.control.modules.volume")()
local media = require("components.control.modules.media")()

-- Control panel widget
local control = wibox.widget({
    homogeneous = true,
    spacing = beautiful.panel_internal_margin,
    min_cols_size = 10,
    min_rows_size = 10,
    forced_num_rows = 0,
    forced_num_cols = 0,
    expand = true,
    layout = wibox.layout.grid
})

local panel_widget = wibox.widget({
    {
        {
            title,
            control,
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

-- settings panel widget
local panel = wibox({
    width = beautiful.panel_minimize_width,
    height = beautiful.panel_minimize_height,
    widget = panel_widget,
    ontop = true
})
awful.placement.top_right(panel, {
    parent = awful.screen.focused(),
    margins = {
        top = beautiful.useless_gap + beautiful.bar_height,
        right = beautiful.useless_gap
    }
})

awesome.connect_signal("panel::control::set", function(on)
    if on then
        panel.width = beautiful.panel_width
        panel.height = beautiful.panel_height
        control:reset()
        control.homogeneous = true
        control.spacing = beautiful.panel_internal_margin
        control.min_cols_size = 10
        control.min_rows_size = 10
        control.forced_num_rows = 15
        control.forced_num_cols = 6
        control.expand = true
        control:add_widget_at(left_buttons_widget, 1, 1, 6, 3)
        control:add_widget_at(small_widgets, 1, 4, 2, 3)
        control:add_widget_at(weather, 3, 4, 4, 3)
        control:add_widget_at(brightness, 7, 1, 3, 6)
        control:add_widget_at(volume, 10, 1, 3, 6)
        control:add_widget_at(media, 13, 1, 3, 6)
    else
        panel.width = beautiful.panel_minimize_width
        panel.height = beautiful.panel_minimize_height
        control:reset()
    end
end)

awesome.connect_signal("theme::reload", function()
    panel_widget.bg = beautiful.panel_bg
    panel_widget.border_color = beautiful.panel_border_color
end)

return {control, panel}
