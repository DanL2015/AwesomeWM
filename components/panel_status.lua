local awful = require("awful")
local beautiful = require("beautiful")
local rubato = require("rubato")
local naughty = require("naughty")

local notifs = require("components.notifications")
local control = require("components.control")

local panel_visible = false

awesome.connect_signal("panel::toggle", function()
    panel_visible = not panel_visible
    if panel_visible then
        notifs.update_screen()
        control.update_screen()
        notifs.flyin()
        control.flyin()
    else
        notifs.flyout()
        control.flyout()
    end
end)

awesome.connect_signal("panel::control::set", function(state)
    if state then
        notifs.minimize()
        control.maximize()
    else
        notifs.maximize()
        control.minimize()
    end
end)