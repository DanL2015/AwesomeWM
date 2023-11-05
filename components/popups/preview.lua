local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local bling = require("bling")

bling.widget.task_preview.enable {
    x = 20,
    y = 20,
    height = 200,
    width = 300,
    placement_fn = function(c)
        awful.placement.top(c,
            { parent = awful.screen.focused(), margins = { top = beautiful.bar_height + beautiful.margins } })
    end,
    widget_structure = {
        {
            {
                id = 'icon_role',
                widget = awful.widget.clienticon,
            },
            {
                id = 'name_role',
                wrap = "word",
                widget = wibox.widget.textbox,
            },
            layout = wibox.layout.fixed.horizontal
        },
        {
            id = 'image_role',
            resize = true,
            valign = 'center',
            halign = 'center',
            widget = wibox.widget.imagebox,
        },
        layout = wibox.layout.fixed.vertical
    }
}
