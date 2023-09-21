local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

local function buttons()
    return gears.table.join(
        awful.button(
            {}, 1,
            function()
                awesome.emit_signal("panel::notifications")
            end
        )
    )
end

local function create_widget()
    local image = wibox.widget {
        image = beautiful.icon_bell,
        widget = wibox.widget.imagebox,
    }

    local widget = require("widgets.clickable_widget")(image)

    widget:buttons(buttons())

    local tooltip = awful.tooltip {
        objects = { widget },
        markup = "<b>Notifications</b>"
    }

    return widget
end

return create_widget
