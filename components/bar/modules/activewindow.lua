local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local function update_widget(widget)
    local c = client.focus
    if c ~= nil then
        widget:set_text((c.class:gsub("^%l", string.upper)))
    else
        widget:set_text("Desktop")
    end
end

local function create_widget()
    local textbox = wibox.widget.textbox()
    client.connect_signal("focus", function(...) update_widget(textbox) end)
    tag.connect_signal("property::selected", function(...) update_widget(textbox) end)
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
