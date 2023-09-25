local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- settings panel widget
local settings = require("components.panel.panel")()
local panel = wibox({
    width = beautiful.panel_width,
    height = beautiful.panel_height,
    bg = beautiful.panel_bg,
    ontop = true,
})

panel:setup({
    {
        settings,
        margins = beautiful.panel_internal_margin,
        layout = wibox.container.margin,
    },
    bg = beautiful.panel_bg,
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 8)
    end,
    border_color = beautiful.panel_border_color,
    border_width = beautiful.border_width,
    widget = wibox.container.background,
})

-- Signals
awesome.connect_signal("panel::toggle", function()
    awful.placement.top_right(panel, {
        parent = awful.screen.focused(),
        margins = { top = beautiful.bar_height + beautiful.useless_gap, right = beautiful.useless_gap },
    })
    panel.visible = not panel.visible
end)
