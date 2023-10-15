local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")
local create_background = require("helpers.background_widget")
local create_clickable = require("helpers.clickable_widget")

local function create_widget()
    local title = wibox.widget({
        markup = "<b>Notifications</b>",
        valign = "center",
        halign = "left",
        widget = wibox.widget.textbox
    })

    local widget = create_background(wibox.widget({
        title,
        forced_height = beautiful.panel_title_height,
        margins = beautiful.panel_internal_margin,
        layout = wibox.container.margin
    }), 0, 0)

    return widget
end

return create_widget
