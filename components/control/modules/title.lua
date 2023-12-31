local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")
local create_background = require("helpers.background_widget")
local create_clickable = require("helpers.clickable_widget")

local function create_widget()
    local title = wibox.widget({
        markup = "<b>Control</b>",
        valign = "center",
        halign = "left",
        widget = wibox.widget.textbox
    })

    local button = wibox.widget({
        markup = "",
        font = beautiful.font_icon,
        forced_width = beautiful.panel_title_button_icon_size,
        forced_height = beautiful.panel_title_button_icon_size,
        valign = "center",
        halign = "center",
        widget = wibox.widget.textbox
    })

    button:buttons(gears.table.join(awful.button({}, 1, function()
        if not button.on then
            button.on = false
        end
        button.on = not button.on
        if button.on then
            button.markup = ""
            awesome.emit_signal("panel::control::set", true)
        else
            button.markup = ""
            awesome.emit_signal("panel::control::set", false)
        end
    end)))

    local widget = create_background(wibox.widget({
        {
            title,
            nil,
            create_clickable(button, button, 0, 0),
            layout = wibox.layout.align.horizontal
        },
        forced_height = beautiful.panel_title_height,
        margins = beautiful.panel_internal_margin,
        layout = wibox.container.margin
    }), 0, 0)

    awesome.connect_signal("panel::toggle", function()
        button.on = true
        button.markup = ""
    end)

    return widget
end

return create_widget
