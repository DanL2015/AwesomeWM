local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local naughty = require("naughty")

local function update(progressbar, icon, tooltip, device)
    if device.percentage < 25 then
        progressbar.color = beautiful.red
    elseif device.percentage < 50 then
        progressbar.color = beautiful.orange
    elseif device.percentage < 75 then
        progressbar.color = beautiful.blue
    else
        progressbar.color = beautiful.green
    end
    progressbar.value = device.percentage
    if device.state == 1 or device.state == 4 then
        icon.visible = true
    else
        icon.visible = false
    end
    tooltip.markup = "<b>Battery</b>: " .. math.floor(device.percentage) .. "%"
end

local function create_widget()
    local progressbar = wibox.widget({
        max_value = 100,
        value = 100,
        border_width = 0,
        color = beautiful.green,
        background_color = beautiful.bg2,
        widget = wibox.widget.progressbar,
        shape = helpers.rrect()
    })

    local icon = wibox.widget({
        font = beautiful.font_icon,
        markup = "",
        valign = "center",
        halign = "center",
        widget = wibox.widget.textbox
    })

    local stack = wibox.widget({
        {
            progressbar,
            forced_height = beautiful.dpi(48),
            direction = "east",
            layout = wibox.container.rotate
        },
        {
            icon,
            fg = beautiful.bg0,
            layout = wibox.container.background,
        },
        layout = wibox.layout.stack
    })

    local widget = helpers.add_margin(stack, beautiful.margin[1], beautiful.margin[0])

    local tooltip = helpers.add_tooltip(widget, "<b>Unknown</b>")

    awesome.connect_signal("battery::update", function(device)
        update(progressbar, icon, tooltip, device)
    end)

    return widget
end
return create_widget
