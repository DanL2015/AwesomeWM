local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local add_background = require("helpers.background_widget")

local function create_widget()
    -- Brightness widget
    local brightness_widget = wibox.widget({
        max_value = 100,
        forced_height = beautiful.slider_height,
        widget = wibox.widget.slider
    })

    local brightness_text = wibox.widget({
        markup = "<b>Brightness</b>",
        widget = wibox.widget.textbox
    })

    local brightness = add_background(wibox.widget({
        {
            {
                {
                    brightness_text,
                    brightness_widget,
                    spacing = beautiful.panel_internal_margin,
                    layout = wibox.layout.fixed.vertical
                },
                valign = "center",
                halign = "center",
                layout = wibox.container.place
            },
            layout = wibox.layout.stack
        },
        margins = beautiful.panel_internal_margin,
        layout = wibox.container.margin
    }), 0, 0)
    awesome.connect_signal("daemon::brightness::status", function(stdout)
        brightness_widget.value = stdout
    end)

    brightness_widget:connect_signal("property::value", function(_, new_value)
        brightness_text.markup = "<b>Brightness</b>: " .. tostring(new_value) .. "%"
        awesome.emit_signal("daemon::brightness::update", new_value)
    end)

    return brightness
end

return create_widget
