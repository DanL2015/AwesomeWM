local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local naughty = require("naughty")

local M = {}

function M.random()
    local val = math.random(0, 360)
    M.arcchart.start_angle = val
    M.arcchart.value = 30
end

function M.reset()
    M.arcchart.value = nil
    M.background.fg = beautiful.red
end

function M.validate()
    M.background.fg = beautiful.green
end

function M.new()
    math.randomseed(os.time())
    M.icon = wibox.widget({
        markup = "",
        valign = "center",
        halign = "center",
        font = beautiful.font_icon_large,
        widget = wibox.widget.textbox
    })

    M.background = wibox.widget({
            M.icon,
            fg = beautiful.red,
            bg = beautiful.bg1,
            shape = helpers.circle(),
            layout = wibox.container.background
        })

    M.arcchart = wibox.widget({
        M.background,
        colors = { beautiful.blue },
        thickness = beautiful.dpi(8),
        rounded_edge = true,
        min_value = 0,
        max_value = 100,
        start_angle = 0,
        forced_width = beautiful.icon_size[4],
        forced_height = beautiful.icon_size[4],
        layout = wibox.container.arcchart
    })

    M.widget = helpers.add_margin(helpers.add_bg0(helpers.add_margin(M.arcchart, beautiful.margin[1], beautiful.margin[1])), beautiful.margin[4],
        beautiful.margin[4])

    return M.widget
end

return M
