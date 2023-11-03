local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local add_background = require("helpers.background_widget")

local function create_widget()
    -- Volume widget
    local volume_widget = wibox.widget({
        max_value = 100,
        forced_height = beautiful.slider_height,
        widget = wibox.widget.slider
    })

    local volume_text = wibox.widget({
        markup = "<b>Volume</b>",
        widget = wibox.widget.textbox
    })

    local volume = add_background(wibox.widget({
        {
            {
                {
                    volume_text,
                    volume_widget,
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

    awesome.connect_signal("daemon::volume::status", function(stdout)
        volume_widget.value = stdout
    end)

    volume_widget:connect_signal("property::value", function(_, new_value)
        volume_text.markup = "<b>Volume</b>: " .. tostring(new_value) .. "%"
        awesome.emit_signal("daemon::volume::update", new_value)
    end)

    return volume
end

return create_widget
