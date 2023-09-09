local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")

local function create_widget()
    local textbox = wibox.widget {
        markup = "<b>Daniel Liu</b>",
        widget = wibox.widget.textbox
    }

    local widget = wibox.widget {
        widget = wibox.container.margin,
        left = beautiful.xlarge_space,
        right = beautiful.xlarge_space,
        top = beautiful.large_space,
        bottom = beautiful.large_space,
        textbox,
    }

    return widget
end

return create_widget
