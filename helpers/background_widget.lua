local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local helpers = require("helpers")

local function create_widget(widget, hspace, vspace, bg_color)
    hspace = hspace or beautiful.xlarge_space
    vspace = vspace or beautiful.small_space
    local bg = bg_color or beautiful.bg1
    local background = wibox.widget({
        widget,
        layout = wibox.container.background,
        bg = bg,
        shape = helpers.rounded_rect(8)
    })
    local widget = wibox.widget({
        background,
        layout = wibox.container.margin,
        left = hspace,
        right = hspace,
        top = vspace,
        bottom = vspace
    })

    return widget
end

return create_widget
