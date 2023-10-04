local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local function create_widget()
    local widget = wibox.widget {
        widget = wibox.container.margin,
        left = beautiful.xlarge_space,
        right = beautiful.xlarge_space,
        top = beautiful.large_space,
        bottom = beautiful.large_space,
        wibox.widget.textclock('%a %b %d %l:%M %p'),
    }
    return require("helpers.background_widget")(widget)
end
return create_widget
