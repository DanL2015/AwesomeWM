local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

local function create_widget()
    local clock = wibox.widget({
        format = '%I\n%M',
        valign = "center",
        halign = "center",
        widget = wibox.widget.textclock,
    })

    local tooltip = helpers.add_tooltip(clock, "<b>Date</b>: "..os.date("%A, %B %e"))
    return helpers.add_margin(clock)
end
return create_widget
