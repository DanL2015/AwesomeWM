local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

local function buttons()
    return gears.table.join(
        awful.button(
            {}, 1,
            function() app_menu:toggle() end
        )
    )
end

local function create_widget()
    local image = wibox.widget {
        image = beautiful.icon_search,
        widget = wibox.widget.imagebox,
    }

    local widget = require("helpers.clickable_widget")(image)

    widget:buttons(buttons())

    local tooltip = awful.tooltip {
        objects = { widget },
        markup = "<b>Search</b>"
    }

    return widget
end

return create_widget
