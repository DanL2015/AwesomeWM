local awful = require("awful")
local beautiful = require("beautiful")

local notifs = require("components.notifications")
local notifs_widget = notifs[1]
local notifs_wibox = notifs[2]

local control = require("components.control")
local control_widget = control[1]
local control_wibox = control[2]

local active_panel = 1
local panel_visible = false

awesome.connect_signal("panel::toggle", function()
    panel_visible = not panel_visible
    control_wibox.visible = panel_visible
    notifs_wibox.visible = panel_visible
    if panel_visible then
        awesome.emit_signal("panel::control::set", true)
    end
end)

awesome.connect_signal("panel::control::set", function(state)
    if state then
        notifs_wibox.height = awful.screen.focused().geometry.height - beautiful.bar_height - beautiful.panel_height -
                                  beautiful.useless_gap - beautiful.useless_gap - beautiful.panel_internal_margin
        awful.placement.top_right(notifs_wibox, {
            parent = awful.screen.focused(),
            margins = {
                top = beautiful.useless_gap + beautiful.bar_height + beautiful.panel_internal_margin +
                    beautiful.panel_height,
                right = beautiful.useless_gap
            }
        })
    else
        notifs_wibox.height = awful.screen.focused().geometry.height - beautiful.bar_height - beautiful.panel_minimize_height -
                                  beautiful.useless_gap - beautiful.useless_gap - beautiful.panel_internal_margin
        awful.placement.top_right(notifs_wibox, {
            parent = awful.screen.focused(),
            margins = {
                top = beautiful.useless_gap + beautiful.bar_height + beautiful.panel_internal_margin +
                    beautiful.panel_minimize_height,
                right = beautiful.useless_gap
            }
        })
    end
end)

awesome.connect_signal("theme::reload", function()
    control_wibox.bg = beautiful.panel_bg
    notifs_wibox.bg = beautiful.panel_bg
end)
