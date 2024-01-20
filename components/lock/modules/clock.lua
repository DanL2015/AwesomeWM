local wibox = require("wibox")
local beautiful = require("beautiful")

local M = {}

function M.new()
    M.date = wibox.widget({
        valign = "center",
        halign = "center",
        font = beautiful.font_medium,
        format = "%A, %B %e",
        widget = wibox.widget.textclock
    })

    M.time = wibox.widget({
        valign = "center",
        halign = "center",
        font = beautiful.font_large,
        format = "%l:%M %p",
        widget = wibox.widget.textclock
    })

    M.widget = wibox.widget({
        M.time,
        M.date,
        layout = wibox.layout.fixed.vertical
    })

    return M.widget
end

return M
